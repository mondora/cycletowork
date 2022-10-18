const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const { Constant } = require('../../utility/constant');
const { loggerLog, loggerError } = require('../../utility/logger');

const sendNotification = async (listDeviceToken, title, description, data) => {
    const payload = {
        data: data || {},
        notification: {
            title: title,
            body: description,
        },
    };
    const listToken = listDeviceToken.map((x) => x.token);
    const response = await admin.messaging().sendToDevice(listToken, payload);
    for (let index = 0; index < response.results.length; index++) {
        const result = response.results[index];

        if (result.error) {
            const id = listDeviceToken[index].id;
            await removeDeviceTokenFromId(id);
        }
    }
};

const saveDeviceToken = async (uid, token) => {
    const id = uuidv4();
    const now = new Date();
    const expireDate = new Date(now);
    expireDate.setMonth(now.getMonth() + 1);

    const data = {
        id: id,
        uid: uid,
        expireDate: expireDate,
        token: token,
    };
    await admin
        .firestore()
        .collection(Constant.fcmCollectionName)
        .doc(id)
        .update(data, { merge: false });
};

const removeDeviceTokenFromId = async (id) => {
    await admin
        .firestore()
        .collection(Constant.fcmCollectionName)
        .doc(id)
        .delete();
};

const removeDeviceToken = async (token) => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.fcmCollectionName)
        .where('token', '==', token)
        .limit(50)
        .get();

    if (!snapshot.empty) {
        for (let index = 0; index < snapshot.docs.length; index++) {
            const data = snapshot.docs[index].data();
            await removeDeviceTokenFromId(data.id);
        }

        return true;
    } else {
        return false;
    }
};

const getListDeviceToken = async (uid) => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.fcmCollectionName)
        .where('uid', '==', uid)
        .limit(50)
        .get();

    if (!snapshot.empty) {
        const listDeviceToken = [];

        for (let index = 0; index < snapshot.docs.length; index++) {
            const data = snapshot.docs[index].data();
            const expireDate = new Date(data.expireDate.seconds * 1000);
            const now = new Date();
            if (now > expireDate) {
                await removeDeviceTokenFromId(data.id);
            } else {
                listDeviceToken.push(data);
            }
        }

        return listDeviceToken;
    } else {
        return [];
    }
};

const getAllListDeviceToken = async () => {
    const listDeviceToken = [];
    const pageSize = 1000;
    let isFinished = false;
    let last;
    while (!isFinished) {
        let snapshot;
        if (last) {
            snapshot = await admin
                .firestore()
                .collection(Constant.fcmCollectionName)
                .orderBy('expireDate')
                .startAfter(last.data().expireDate)
                .limit(pageSize)
                .get();
        } else {
            snapshot = await admin
                .firestore()
                .collection(Constant.fcmCollectionName)
                .orderBy('expireDate')
                .limit(pageSize)
                .get();
        }

        if (!snapshot.empty) {
            last = snapshot.docs[snapshot.docs.length - 1];

            for (let index = 0; index < snapshot.docs.length; index++) {
                const data = snapshot.docs[index].data();
                const expireDate = new Date(data.expireDate.seconds * 1000);
                const now = new Date();
                if (now > expireDate) {
                    await removeDeviceTokenFromId(data.id);
                } else {
                    listDeviceToken.push(data);
                }
            }
        } else {
            isFinished = true;
        }
    }

    return listDeviceToken;
};

module.exports = {
    sendNotification,
    saveDeviceToken,
    removeDeviceTokenFromId,
    removeDeviceToken,
    getListDeviceToken,
    getAllListDeviceToken,
};
