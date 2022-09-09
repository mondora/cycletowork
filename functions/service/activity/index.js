const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');
const { getUserInfo } = require('../user');
const { loggerDebug } = require('../../utility/logger');

const saveUserActivity = async (uid, userActivity) => {
    const data = {
        calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
        co2: admin.firestore.FieldValue.increment(userActivity.co2),
        distance: admin.firestore.FieldValue.increment(userActivity.distance),
        steps: admin.firestore.FieldValue.increment(userActivity.steps),
        averageSpeed: userActivity.averageSpeed,
        maxSpeed: userActivity.maxSpeed,
    };

    await admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(data, { merge: true });

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
    const dataUser = {
        calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
        co2: admin.firestore.FieldValue.increment(userActivity.co2),
        distance: admin.firestore.FieldValue.increment(userActivity.distance),
        steps: admin.firestore.FieldValue.increment(userActivity.steps),
        averageSpeed: userActivity.averageSpeed,
        maxSpeed: userActivity.maxSpeed,
    };

    const dataCompany = {
        calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
        co2: admin.firestore.FieldValue.increment(userActivity.co2),
        distance: admin.firestore.FieldValue.increment(userActivity.distance),
        steps: admin.firestore.FieldValue.increment(userActivity.steps),
        averageSpeed: userActivity.averageSpeed,
        maxSpeed: userActivity.maxSpeed,
    };

    const registeredInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .get();

    if (!registeredInfo.exists) {
        throw new Error(Constant.userNotFoundError);
    }

    const now = Date.now();
    if (
        registeredInfo.startTimeChallenge > now ||
        registeredInfo.stopTimeChallenge < now
    ) {
        throw new Error(Constant.challengeIsNotOpenError);
    }

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivityId)
        .set(userActivity, { merge: false });

    const alreadyStarted = registeredInfo.data().alreadyStarted;

    if (!alreadyStarted) {
        dataCompany.employeesNumberRegistered =
            admin.firestore.FieldValue.increment(1);

        dataUser.alreadyStarted = true;
    }

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .update(dataUser, { merge: true });

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .doc(companyId)
        .update(dataCompany, { merge: true });
};

const getListUserActivity = async (uid, startDate, pageSize = 100) => {
    let snapshot;
    if (startDate) {
        snapshot = await admin
            .firestore()
            .collection(Constant.usersCollectionName)
            .doc(uid)
            .collection(Constant.userActivityCollectionName)
            .orderBy('startTime', 'desc')
            .startAfter(startDate)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.usersCollectionName)
            .doc(uid)
            .collection(Constant.userActivityCollectionName)
            .orderBy('startTime', 'desc')
            .limit(pageSize)
            .get();
    }

    if (!snapshot.empty) {
        return snapshot.docs.map((doc) => doc.data());
    } else {
        return [];
    }
};

module.exports = {
    saveUserActivity,
    getListUserActivity,
};
