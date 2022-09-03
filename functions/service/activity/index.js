const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');

const saveUserActivity = async (uid, userActivity, userActivitySummary) => {
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivity.userActivityId)
        .set(userActivity, { merge: false });

    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivitySummaryCollectionName)
        .doc(uid)
        .set(userActivitySummary, { merge: true });
};

const saveUserActivityForChallenge = async (uid, userActivity) => {};

module.exports = {
    saveUserActivity,
    saveUserActivityForChallenge,
};
