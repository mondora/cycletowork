const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');

const addDepartment = async (department) => {
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivity.userActivityId)
        .set(userActivity, { merge: false });
};

module.exports = {
    addDepartment,
};
