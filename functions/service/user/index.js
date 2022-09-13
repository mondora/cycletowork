const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const { Constant } = require('../../utility/constant');
const { loggerDebug, loggerError } = require('../../utility/logger');
const { sgMail } = require('../../utility/mailer');
const { sendVerifiyCode } = require('../../utility/email_template');

const createUser = async (user) => {
    const uid = user.uid;

    const data = {
        admin: false,
        userType: Constant.UserType.Other,
        email: user.email,
        displayName: user.displayName,
        uid: uid,
        emailVerified: user.emailVerified,
        photoURL: user.photoURL,
        createUserDate: Date.now(),
        averageSpeed: 0,
        calorie: 0,
        co2: 0,
        distance: 0,
        maxSpeed: 0,
        steps: 0,
    };

    await admin.auth().setCustomUserClaims(uid, {
        admin: false,
        verified: false,
    });

    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .set(data, { merge: false });
};

const saveChallengeUser = async (uid, challengeId, data) => {
    const dataUser = {
        listChallengeIdRegister: admin.firestore.FieldValue.arrayUnion(
            ...[challengeId]
        ),
        ...data,
    };
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(dataUser, { merge: true });
};

const deleteUser = async (user) => {
    const uid = user.uid;
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .delete();
};

const getUserInfo = async (uid) => {
    const userInfo = await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .get();

    if (userInfo.exists) {
        return userInfo.data();
    } else {
        throw new Error(Constant.userNotFoundError);
    }
};

const updateUserInfo = async (uid, data) => {
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(data, { merge: true });
};

const sendEmailVerificationCode = async (uid, email, displayName) => {
    const userInfo = await getUserInfo(uid);
    const code = randomInteger(100000, 999999);
    const now = new Date();
    const expireCode = new Date(now);
    expireCode.setMinutes(now.getMinutes() + 5);
    const dataCode = {
        connectedEmail: [],
    };
    if (userInfo && userInfo.connectedEmail && userInfo.connectedEmail.length) {
        dataCode.connectedEmail = userInfo.connectedEmail;
        const index = userInfo.connectedEmail.findIndex(
            (x) => x.email === email
        );
        if (index >= 0) {
            dataCode.connectedEmail[index] = {
                code: code,
                email: email,
                verified: false,
                expireCode: expireCode,
            };
        } else {
            dataCode.connectedEmail.push({
                code: code,
                email: email,
                verified: false,
                expireCode: expireCode,
            });
        }
    } else {
        dataCode.connectedEmail.push({
            code: code,
            email: email,
            verified: false,
            expireCode: expireCode,
        });
    }
    await updateUserInfo(uid, dataCode);
    const msg = {
        from: 'info@sataspes.net',
        to: email,
        subject: 'Cycle2Work - verifica email',
        html: sendVerifiyCode(code),
    };

    sgMail
        .send(msg)
        .then((response) => {})
        .catch((error) => {
            loggerError('sgMail error: ', error);
        });
};

const verifiyEmailCode = async (uid, email, code) => {
    const userInfo = await getUserInfo(uid);
    const dataCode = {};
    if (
        !userInfo ||
        !userInfo.connectedEmail ||
        !userInfo.connectedEmail.length
    ) {
        throw new Error(Constant.userNotFoundError);
    }

    dataCode.connectedEmail = userInfo.connectedEmail;
    const index = userInfo.connectedEmail.findIndex((x) => x.email === email);

    if (index === -1) {
        throw new Error(Constant.userNotFoundError);
    }

    const connectedEmailInfo = dataCode.connectedEmail[index];
    if (connectedEmailInfo.code != code) {
        throw new Error(Constant.codeIsNotValid);
    }

    const expireCode = new Date(connectedEmailInfo.expireCode.seconds * 1000);
    const now = new Date();
    if (now > expireCode) {
        throw new Error(Constant.codeIsExpired);
    }

    dataCode.connectedEmail[index] = {
        email: email,
        verified: true,
    };
    await updateUserInfo(uid, dataCode);
};

const randomInteger = (min, max) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
};

module.exports = {
    createUser,
    deleteUser,
    getUserInfo,
    updateUserInfo,
    sendEmailVerificationCode,
    verifiyEmailCode,
    saveChallengeUser,
};
