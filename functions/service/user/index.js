const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');

const createUser = async (user) => {
    const uid = user.uid;
    const data = {
        admin: false,
        userType: Constant.UserType.Other,
        email: user.email,
        displayName: user.displayName,
    };
    await admin.auth().setCustomUserClaims(uid, { admin: false });
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .set(data, { merge: false });
};

const deleteUser = async (user) => {
    const uid = user.uid;
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .delete();
};

const setAdminUser = async (uid) => {
    const data = { admin: true };
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .set(data, { merge: true });
};

module.exports = { createUser, deleteUser, setAdminUser };
