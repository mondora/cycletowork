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

const deleteAccount = async (uid) => {
    let userInfoData;
    const userRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid);

    const deleteAccountRef = admin
        .firestore()
        .collection(Constant.deleteDocsCollectionName);

    await admin.firestore().runTransaction(async (t) => {
        const userInfo = await t.get(userRef);
        if (userInfo.exists) {
            userInfoData = userInfo.data();
        } else {
            throw new Error(Constant.userNotFoundError);
        }
        const userToDelete = {
            id: uuidv4(),
            path: `/${Constant.usersCollectionName}/${uid}`,
            isDone: false,
            requestDate: Date.now(),
        };
        const userActivityToDelete = {
            id: uuidv4(),
            path: `/${Constant.usersCollectionName}/${uid}/${Constant.userActivityCollectionName}`,
            isDone: false,
            requestDate: Date.now(),
        };
        t.create(deleteAccountRef.doc(userToDelete.id), userToDelete);
        t.create(
            deleteAccountRef.doc(userActivityToDelete.id),
            userActivityToDelete
        );
        const listFile = userInfoData.listFile;
        if (listFile && listFile.length) {
            for (let index = 0; index < listFile.length; index++) {
                const file = listFile[index];

                const userFileToDelete = {
                    id: uuidv4(),
                    path: file,
                    isDone: false,
                    isStorageFile: true,
                    requestDate: Date.now(),
                };

                t.create(
                    deleteAccountRef.doc(userFileToDelete.id),
                    userFileToDelete
                );
            }
        }

        const listRegisterdChallenge = userInfoData.listChallengeIdRegister;
        if (listRegisterdChallenge && listRegisterdChallenge.length) {
            for (
                let index = 0;
                index < listRegisterdChallenge.length;
                index++
            ) {
                const challengeId = listRegisterdChallenge[index];

                const userToDeleteInChallenge = {
                    id: uuidv4(),
                    path: `/${Constant.challengeCollectionName}/${challengeId}/${Constant.usersCollectionName}/${uid}`,
                    isDone: false,
                    requestDate: Date.now(),
                };
                const userActivityToDeleteInChallenge = {
                    id: uuidv4(),
                    path: `/${Constant.challengeCollectionName}/${challengeId}/${Constant.usersCollectionName}/${uid}/${Constant.userActivityCollectionName}`,
                    isDone: false,
                    requestDate: Date.now(),
                };
                t.create(
                    deleteAccountRef.doc(userToDeleteInChallenge.id),
                    userToDeleteInChallenge
                );
                t.create(
                    deleteAccountRef.doc(userActivityToDeleteInChallenge.id),
                    userActivityToDeleteInChallenge
                );
            }
        }
    });
    await admin.auth().deleteUser(uid);
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
    let userInfoData;
    const userRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid);

    await admin.firestore().runTransaction(async (t) => {
        const userInfo = await t.get(userRef);
        if (userInfo.exists) {
            userInfoData = userInfo.data();
        } else {
            throw new Error(Constant.userNotFoundError);
        }

        t.update(userRef, data, { merge: true });

        const listRegisterdChallenge = userInfoData.listChallengeIdRegister;
        if (listRegisterdChallenge && listRegisterdChallenge.length) {
            for (
                let index = 0;
                index < listRegisterdChallenge.length;
                index++
            ) {
                const challengeId = listRegisterdChallenge[index];
                const userInChallengeRef = admin
                    .firestore()
                    .collection(Constant.challengeCollectionName)
                    .doc(challengeId)
                    .collection(Constant.usersCollectionName)
                    .doc(uid);

                t.update(userInChallengeRef, data, { merge: true });
            }
        }
    });
};

const sendEmailVerificationCode = async (uid, email, displayName) => {
    const userInfo = await getUserInfo(uid);
    const code = randomInteger(100000, 999999);
    const now = new Date();
    const expireCode = new Date(now);
    expireCode.setMinutes(now.getMinutes() + 120);
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

    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(dataCode, { merge: true });

    const msg = {
        from: 'info@mondora.com',
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
    const index = userInfo.connectedEmail.findIndex(
        (x) =>
            x.email.split(' ').join('').toLowerCase() ===
            email.split(' ').join('').toLowerCase()
    );

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
        email: email.split(' ').join('').toLowerCase(),
        verified: true,
    };

    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(dataCode, { merge: true });
};

const randomInteger = (min, max) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
};

module.exports = {
    createUser,
    deleteAccount,
    getUserInfo,
    updateUserInfo,
    sendEmailVerificationCode,
    verifiyEmailCode,
    saveChallengeUser,
};
