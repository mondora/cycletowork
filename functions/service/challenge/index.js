const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');
const { saveChallengeUser, getUserInfo } = require('../user');
const { saveCompany } = require('../company');

const getActiveChallengeList = async () => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .where('published', '==', true)
        .where('stopTime', '>=', Date.now())
        .limit(100)
        .get();

    if (!snapshot.empty) {
        return snapshot.docs.map((doc) => doc.data());
    } else {
        return [];
    }
};

const registerChallenge = async (uid, challengeRegistry) => {
    const userInfo = await getUserInfo(uid);
    const challengeId = challengeRegistry.challengeId;
    if (!userInfo) {
        throw new Error(Constant.userNotFoundError);
    }

    if (
        userInfo.listChallengeIdRegister &&
        userInfo.listChallengeIdRegister.includes(challengeId)
    ) {
        throw new Error(Constant.userAlreadyRegisteredError);
    }

    if (challengeRegistry.companyToAdd) {
        await saveCompany(challengeRegistry.companyToAdd);
    }
    const data = {
        averageSpeed: 0,
        calorie: 0,
        co2: 0,
        distance: 0,
        maxSpeed: 0,
        steps: 0,
    };

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .set({ challengeRegistry, ...data }, { merge: false });

    const company = challengeRegistry.companySelected;
    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .doc(company.id)
        .set({ company, ...data }, { merge: false });

    await saveChallengeUser(uid, challengeId);
};

module.exports = {
    getActiveChallengeList,
    registerChallenge,
};
