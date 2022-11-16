const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');
const { getUserInfo } = require('../user');
const { loggerDebug } = require('../../utility/logger');

const saveUserActivity = async (uid, userActivity) => {
    let userInfoData, challengeInfoData, userInChallengeInfoData;
    const now = Date.now();
    const userActivityId = userActivity.userActivityId;
    const isChallenge = userActivity.isChallenge;
    const challengeId = userActivity.challengeId;

    const userRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid);

    const userActivityRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivityId);

    await admin.firestore().runTransaction(async (t) => {
        const userInfo = await t.get(userRef);

        if (userInfo.exists) {
            userInfoData = userInfo.data();
        } else {
            throw new Error(Constant.userNotFoundError);
        }

        if (!isChallenge || !userActivity.challengeId) {
            const data = {
                calorie: admin.firestore.FieldValue.increment(
                    userActivity.calorie
                ),
                co2: admin.firestore.FieldValue.increment(userActivity.co2),
                distance: admin.firestore.FieldValue.increment(
                    userActivity.distance
                ),
                steps: admin.firestore.FieldValue.increment(userActivity.steps),
                averageSpeed: userActivity.averageSpeed,
                maxSpeed: userActivity.maxSpeed,
            };

            t.update(userRef, data, { merge: true });
            t.set(userActivityRef, userActivity, { merge: false });
            return;
        }

        loggerDebug(
            'saveUserActivityChallenge  UID:',
            uid,
            'userActivity:',
            userActivity
        );

        const challengeRef = admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId);

        const userInChallengeRef = admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .doc(uid);

        const userActivityInChallengeRef = admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .doc(uid)
            .collection(Constant.userActivityCollectionName)
            .doc(userActivityId);

        if (
            !userInfoData.listChallengeIdRegister ||
            !userInfoData.listChallengeIdRegister.includes(challengeId)
        ) {
            throw new Error(Constant.userNotRegisteredForChallengeError);
        }

        const challengeInfo = await t.get(challengeRef);
        if (challengeInfo.exists) {
            challengeInfoData = challengeInfo.data();
        } else {
            throw new Error(Constant.challengeNotFoundError);
        }

        if (challengeInfoData.startTime > now) {
            throw new Error(Constant.challengeNotOpenedError);
        }

        if (challengeInfoData.stopTime < now) {
            throw new Error(Constant.challengeIsExpierdError);
        }

        if (!challengeInfoData.published) {
            throw new Error(Constant.challengeIsNotPublishedError);
        }

        const userInChallengeInfo = await t.get(userInChallengeRef);
        if (userInChallengeInfo.exists) {
            userInChallengeInfoData = userInChallengeInfo.data();
        } else {
            throw new Error(Constant.userAlreadyRegisteredError);
        }

        const alreadyStarted = userInChallengeInfoData.alreadyStarted;
        const companyId = userInChallengeInfoData.companyId;
        const companySizeCategory = userInChallengeInfoData.companySizeCategory;
        const departmentName = userInChallengeInfoData.departmentName;

        const dataUser = {
            calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
            co2: admin.firestore.FieldValue.increment(userActivity.co2),
            distance: admin.firestore.FieldValue.increment(
                userActivity.distance
            ),
            steps: admin.firestore.FieldValue.increment(userActivity.steps),
            averageSpeed: userActivity.averageSpeed,
            maxSpeed: userActivity.maxSpeed,
            alreadyStarted: true,
        };

        t.update(userInChallengeRef, dataUser, { merge: true });
        t.set(userActivityInChallengeRef, userActivity, { merge: false });

        const dataCompany = {
            calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
            co2: admin.firestore.FieldValue.increment(userActivity.co2),
            distance: admin.firestore.FieldValue.increment(
                userActivity.distance
            ),
            steps: admin.firestore.FieldValue.increment(userActivity.steps),
            averageSpeed: userActivity.averageSpeed,
            maxSpeed: userActivity.maxSpeed,
        };

        if (!alreadyStarted) {
            dataCompany.employeesNumberRegistered =
                admin.firestore.FieldValue.increment(1);
        }
        t.update(
            challengeRef.collection(companySizeCategory).doc(companyId),
            dataCompany,
            { merge: true }
        );

        if (departmentName && departmentName != '') {
            const dataDepartment = {
                calorie: admin.firestore.FieldValue.increment(
                    userActivity.calorie
                ),
                co2: admin.firestore.FieldValue.increment(userActivity.co2),
                distance: admin.firestore.FieldValue.increment(
                    userActivity.distance
                ),
                steps: admin.firestore.FieldValue.increment(userActivity.steps),
                averageSpeed: userActivity.averageSpeed,
                maxSpeed: userActivity.maxSpeed,
            };
            t.update(
                challengeRef
                    .collection(companySizeCategory)
                    .doc(companyId)
                    .collection(Constant.departmentCollectionName)
                    .doc(departmentName),
                dataDepartment,
                { merge: true }
            );
        }

        const data = {
            calorie: admin.firestore.FieldValue.increment(userActivity.calorie),
            co2: admin.firestore.FieldValue.increment(userActivity.co2),
            distance: admin.firestore.FieldValue.increment(
                userActivity.distance
            ),
            steps: admin.firestore.FieldValue.increment(userActivity.steps),
            averageSpeed: userActivity.averageSpeed,
            maxSpeed: userActivity.maxSpeed,
        };

        t.update(userRef, data, { merge: true });
        t.set(userActivityRef, userActivity, { merge: false });
    });
};

const saveUserActivityLocationData = async (
    uid,
    userActivity,
    listLocationData,
    listLocationDataUnFiltred
) => {
    const userActivityId = userActivity.userActivityId;

    const userRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid);

    const userActivityRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivityId);

    const listLocationDataRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivityId)
        .collection('listLocationData')
        .doc(userActivityId);

    const listLocationDataUnFiltredRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .collection(Constant.userActivityCollectionName)
        .doc(userActivityId)
        .collection('listLocationDataUnFiltred')
        .doc(userActivityId);

    await admin.firestore().runTransaction(async (t) => {
        const userInfo = await t.get(userRef);

        if (!userInfo.exists) {
            throw new Error(Constant.userNotFoundError);
        }

        t.update(userActivityRef, { isSendedToReview: 1 }, { merge: true });

        t.set(
            listLocationDataRef,
            { listLocationData: listLocationData },
            { merge: false }
        );
        t.set(
            listLocationDataUnFiltredRef,
            { listLocationData: listLocationDataUnFiltred },
            {
                merge: false,
            }
        );
    });
};

const checkUserActivity = async () => {
    const challengeId = '8fffc6ee-529f-4fe9-a848-e5ed40f7131a';
    const snapshotUsers = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .get();

    for (let index = 0; index < snapshotUsers.docs.length; index++) {
        const user = snapshotUsers.docs[index].data();

        if (!user.alreadyStarted) {
            continue;
        }

        await admin
            .firestore()
            .collection(Constant.usersCollectionName)
            .doc(user.uid)
            .update(
                {
                    averageSpeed: user.averageSpeed,
                    calorie: user.calorie,
                    co2: user.co2,
                    distance: user.distance,
                    maxSpeed: user.maxSpeed,
                    steps: user.steps,
                },
                { merge: true }
            );

        const snapshotUsersActivity = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .doc(user.uid)
            .collection(Constant.userActivityCollectionName)
            .get();

        for (
            let indexActivity = 0;
            indexActivity < snapshotUsersActivity.docs.length;
            indexActivity++
        ) {
            const userActivity =
                snapshotUsersActivity.docs[indexActivity].data();

            await admin
                .firestore()
                .collection(Constant.usersCollectionName)
                .doc(user.uid)
                .collection(Constant.userActivityCollectionName)
                .doc(userActivity.userActivityId)
                .set(userActivity, { merge: true });
        }
    }
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
    saveUserActivityLocationData,
    checkUserActivity,
    getListUserActivity,
};
