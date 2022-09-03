const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');
const { getUserInfo } = require('../user');
const { loggerDebug } = require('../../utility/logger');

const saveUserActivity = async (uid, userActivity, userActivitySummary) => {
    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivitySummaryCollectionName)
        .doc(uid)
        .set(userActivitySummary, { merge: true });

    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivity.userActivityId)
        .set(userActivity, { merge: false });

    if (
        userActivity.isChallenge &&
        userActivity.isChallenge === 1 &&
        userActivity.challengeId
    ) {
        const userInfo = await getUserInfo(uid);
        const challengeId = userActivity.challengeId;
        if (!userInfo) {
            throw new Error(Constant.userNotFoundError);
        }

        if (
            !userInfo.listChallengeIdRegister ||
            !userInfo.listChallengeIdRegister.includes(challengeId)
        ) {
            throw new Error(Constant.userNotRegisteredForChallengeError);
        }

        await saveUserActivityForChallenge(uid, userActivity);
    }
};

const saveUserActivityForChallenge = async (uid, userActivity) => {
    const challengeId = userActivity.challengeId;
    const userActivityId = userActivity.userActivityId;
    const companyId = userActivity.companyId;

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivityId)
        .set(userActivity, { merge: false });

    const data = {
        averageSpeed: admin.firestore.FieldValue.increment(
            userActivity.averageSpeed
        ),
        calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
        co2: admin.firestore.FieldValue.increment(userActivity.co2),
        distance: admin.firestore.FieldValue.increment(userActivity.distance),
        maxSpeed: admin.firestore.FieldValue.increment(userActivity.maxSpeed),
        steps: admin.firestore.FieldValue.increment(userActivity.steps),
    };

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(data, { merge: true });

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .doc(companyId)
        .update(data, { merge: true });
};

module.exports = {
    saveUserActivity,
};
