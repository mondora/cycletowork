const admin = require('firebase-admin');
const { Constant } = require('../../../utility/constant');

const checkAdminUser = async (uid) => {
    const user = await admin.auth().getUser(uid);
    if (user && user.customClaims && user.customClaims.admin) {
        return true;
    } else {
        return false;
    }
};

const setAdminUser = async (uid) => {
    const user = await admin.auth().getUser(uid);
    const data = { ...user.customClaims, admin: true };
    await admin.auth().setCustomUserClaims(uid, data);
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update({ admin: true }, { merge: true });
};

const verifyUserAdmin = async (uid) => {
    const user = await admin.auth().getUser(uid);
    const data = { ...user.customClaims, verified: true };
    await admin.auth().setCustomUserClaims(uid, data);
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update({ verified: true }, { merge: true });
};

const getListUserAdmin = async (nextPageToken, pageSize = 100, filter) => {
    if (filter && filter.email) {
        const result = await admin.auth().getUserByEmail(filter.email);
        return {
            users: [result],
            pagination: {
                hasNextPage: false,
                nextPageToken: null,
            },
        };
    } else {
        const pageToken =
            nextPageToken && nextPageToken !== '' ? nextPageToken : undefined;
        const result = await admin.auth().listUsers(pageSize, pageToken);
        return {
            users: result.users,
            pagination: {
                hasNextPage: result.pageToken != null,
                nextPageToken: result.pageToken,
            },
        };
    }
};

const getUserInfoFromEmail = async (email) => {
    return await admin.auth().getUserByEmail(email);
};

module.exports = {
    checkAdminUser,
    setAdminUser,
    verifyUserAdmin,
    getListUserAdmin,
    getUserInfoFromEmail,
};
