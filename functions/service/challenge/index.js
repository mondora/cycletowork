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
        rankingCo2: 0,
        rankingPercentRegistered: 0,
        percentRegistered: 0,
    };
    const company = challengeRegistry.companySelected;
    const companySizeCategory = Constant.getCompanySizeCategory(
        company.employeesNumber
    );
    const companyCollectionForSizeCategory =
        Constant.getCompanyCollectionForSizeCategory(company.employeesNumber);
    const companyEmployeesNumber = company.employeesNumber;
    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .set(
            { ...challengeRegistry, ...data, companyEmployeesNumber },
            { merge: false }
        );

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .doc(company.id)
        .set(
            { ...company, ...data, challengeId, companySizeCategory },
            { merge: false }
        );

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companyCollectionForSizeCategory)
        .doc(company.id)
        .set(
            { ...company, ...data, challengeId, companySizeCategory },
            { merge: false }
        );

    const dataUser = {};
    if (challengeRegistry.businessEmail.includes('@mondora.com')) {
        dataUser.userType = 'mondora';
    }

    if (challengeRegistry.isFiabMember && challengeRegistry.fiabCardNumber) {
        dataUser.userType = 'fiab';
        dataUser.fiabCardNumber = challengeRegistry.fiabCardNumber;
    }
    await saveChallengeUser(uid, challengeId, dataUser);
};

const getListRegisterdChallenge = async (uid) => {
    const list = [];
    const userInfo = await getUserInfo(uid);
    if (!userInfo) {
        throw new Error(Constant.userNotFoundError);
    }
    const listRegisterdChallenge = userInfo.listChallengeIdRegister;
    if (!listRegisterdChallenge || !listRegisterdChallenge.length) {
        return list;
    }

    for (let index = 0; index < listRegisterdChallenge.length; index++) {
        const challengeId = listRegisterdChallenge[index];
        const challenge = await getChallengeRegistredInfo(uid, challengeId);
        list.push(challenge);
    }
    return list;
};

const getListActiveRegisterdChallenge = async (uid) => {
    const userInfo = await getUserInfo(uid);
    if (!userInfo) {
        throw new Error(Constant.userNotFoundError);
    }
    const listRegisterdChallenge = userInfo.listChallengeIdRegister;
    if (!listRegisterdChallenge || !listRegisterdChallenge.length) {
        throw new Error(Constant.userNotRegisteredForChallengeError);
    }

    const list = [];
    for (let index = 0; index < listRegisterdChallenge.length; index++) {
        const challengeId = listRegisterdChallenge[index];
        const challenge = await getChallengeRegistredInfo(uid, challengeId);
        if (challenge && challenge.stopTimeChallenge >= Date.now()) {
            list.push(challenge);
        }
    }
    return list;
};

const getChallengeRegistredInfo = async (uid, challengeId) => {
    const challengeRegistredInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .get();

    if (challengeRegistredInfo.exists) {
        return challengeRegistredInfo.data();
    } else {
        throw new Error(Constant.userNotFoundError);
    }
};

const updateUserRankingCo2 = (challengeId) => {
    return admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .orderBy('co2', 'desc')
        .get()
        .then((snapshot) => {
            let updateRankCo2Batch = admin.firestore().batch();
            let index = 0;
            snapshot.docs.forEach((doc) => {
                updateRankCo2Batch.update(doc.ref, { rankingCo2: index + 1 });
                index++;
            });
            return updateRankCo2Batch.commit();
        })
        .catch((error) => {
            loggerError('updateUserRankingCo2 Error, error:', error);
        });
};

const updateCompanyRankingCo2 = (challengeId) => {
    return admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .orderBy('co2', 'desc')
        .get()
        .then((snapshot) => {
            let updateRankCo2Batch = admin.firestore().batch();
            let index = 0;
            snapshot.docs.forEach((doc) => {
                updateRankCo2Batch.update(doc.ref, { rankingCo2: index + 1 });
                index++;
            });
            return updateRankCo2Batch.commit();
        })
        .catch((error) => {
            loggerError('updateCompanyRankingCo2 Error, error:', error);
        });
};

const updateCompanyPercentRegistered = async (
    challengeId,
    documentId,
    newValue
) => {
    const data = {
        percentRegistered:
            (newValue.employeesNumberRegistered * 100) /
            newValue.employeesNumber,
        employeesNumberRegistered: newValue.employeesNumberRegistered,
    };
    const companyCollectionForSizeCategory =
        Constant.getCompanyCollectionForSizeCategory(newValue.employeesNumber);

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .doc(documentId)
        .update(data, { merge: true });

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companyCollectionForSizeCategory)
        .doc(documentId)
        .update(data, { merge: true });
};

const updateCompanyRankingPercentRegistered = (
    challengeId,
    companyCollectionForSizeCategory
) => {
    return admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companyCollectionForSizeCategory)
        .orderBy('percentRegistered', 'desc')
        .get()
        .then((snapshot) => {
            let updateRankingPercentRegisteredBatch = admin.firestore().batch();
            let index = 0;
            snapshot.docs.forEach((doc) => {
                updateRankingPercentRegisteredBatch.update(doc.ref, {
                    rankingPercentRegistered: index + 1,
                });
                index++;
            });
            return updateRankingPercentRegisteredBatch.commit();
        })
        .catch((error) => {
            loggerError(
                'updateCompanyRankingPercentRegistered Error, error:',
                error,
                'companyCollectionForSizeCategory: ',
                companyCollectionForSizeCategory
            );
        });
};

const getListCyclistClassificationByRankingCo2 = async (
    challengeId,
    lastRankingCo2,
    pageSize
) => {
    let snapshot;
    if (lastRankingCo2) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .orderBy('rankingCo2')
            .startAfter(lastRankingCo2)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .orderBy('rankingCo2')
            .limit(pageSize)
            .get();
    }

    if (!snapshot.empty) {
        return snapshot.docs.map((doc) => doc.data());
    } else {
        return [];
    }
};

const getListCompanyClassificationByRankingCo2 = async (
    challengeId,
    lastRankingCo2,
    pageSize
) => {
    let snapshot;
    if (lastRankingCo2) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.companyCollectionName)
            .orderBy('rankingCo2')
            .startAfter(lastRankingCo2)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.companyCollectionName)
            .orderBy('rankingCo2')
            .limit(pageSize)
            .get();
    }

    if (!snapshot.empty) {
        const list = [];
        for (let index = 0; index < snapshot.docs.length; index++) {
            const data = snapshot.docs[index].data();
            if (data.rankingCo2 != 0) {
                list.push(data);
            }
        }
        return list;
    } else {
        return [];
    }
};

const getListCompanyClassificationByRankingPercentRegistered = async (
    challengeId,
    lastPercentRegistered,
    pageSize,
    companyEmployeesNumber
) => {
    const companyCollectionForSizeCategory =
        Constant.getCompanyCollectionForSizeCategory(companyEmployeesNumber);

    let snapshot;
    if (lastPercentRegistered) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companyCollectionForSizeCategory)
            .orderBy('rankingPercentRegistered')
            .startAfter(lastPercentRegistered)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companyCollectionForSizeCategory)
            .orderBy('rankingPercentRegistered')
            .limit(pageSize)
            .get();
    }

    if (!snapshot.empty) {
        const list = [];
        for (let index = 0; index < snapshot.docs.length; index++) {
            const data = snapshot.docs[index].data();
            if (data.percentRegistered != 0) {
                list.push(data);
            }
        }
        return list;
    } else {
        return [];
    }
};

const getUserCyclistClassification = async (challengeId, uid) => {
    const challengeInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid)
        .get();

    if (challengeInfo.exists) {
        return challengeInfo.data();
    } else {
        throw new Error(Constant.cyclistClassificationNotFoundError);
    }
};

const getUserCompanyClassification = async (challengeId, companyId) => {
    const challengeCompanyInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.companyCollectionName)
        .doc(companyId)
        .get();

    if (challengeCompanyInfo.exists) {
        const data = challengeCompanyInfo.data();
        const companyCollectionForSizeCategory =
            Constant.getCompanyCollectionForSizeCategory(data.employeesNumber);

        const challengeCompanyForSizeCategoryInfo = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companyCollectionForSizeCategory)
            .doc(companyId)
            .get();

        if (challengeCompanyForSizeCategoryInfo.exists) {
            const dataCompanyForSizeCategory =
                challengeCompanyForSizeCategoryInfo.data();

            return {
                ...data,
                rankingPercentRegistered:
                    dataCompanyForSizeCategory.rankingPercentRegistered,
            };
        } else {
            throw new Error(Constant.companuClassificationNotFoundError);
        }
    } else {
        throw new Error(Constant.companuClassificationNotFoundError);
    }
};

const getChallengeRegistryFromBusinessEmail = async (
    challengeId,
    businessEmail
) => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .where('businessEmail', '==', businessEmail)
        .limit(1)
        .get();

    if (!snapshot.empty) {
        return snapshot.docs[0].data();
    } else {
        return null;
    }
};

module.exports = {
    getActiveChallengeList,
    registerChallenge,
    getListActiveRegisterdChallenge,
    getListRegisterdChallenge,
    updateUserRankingCo2,
    updateCompanyRankingCo2,
    updateCompanyRankingPercentRegistered,
    getListCyclistClassificationByRankingCo2,
    getListCompanyClassificationByRankingCo2,
    getListCompanyClassificationByRankingPercentRegistered,
    getUserCyclistClassification,
    getUserCompanyClassification,
    updateCompanyPercentRegistered,
    getChallengeRegistryFromBusinessEmail,
};
