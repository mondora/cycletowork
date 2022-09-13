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
    let userInfoData, challengeInfoData, companyInfoData;
    const now = Date.now();
    const challengeId = challengeRegistry.challengeId;
    const businessEmail = challengeRegistry.businessEmail;
    const isCyclist = challengeRegistry.isCyclist;
    const isChampion = challengeRegistry.isChampion;
    const companyId = challengeRegistry.companyId;
    const isFiabMember = challengeRegistry.isFiabMember;
    const fiabCardNumber = challengeRegistry.fiabCardNumber;
    const companyEmployeesNumber = challengeRegistry.companyEmployeesNumber;
    const companySizeCategory = Constant.getCompanySizeCategory(
        companyEmployeesNumber
    );
    const companyToAdd = challengeRegistry.companyToAdd;

    const userRef = admin
        .firestore()
        .collection(Constant.usersCollectionName)
        .doc(uid);

    const userInChallengeRef = admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.usersCollectionName)
        .doc(uid);

    const challengeRef = admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId);

    const companyRef = admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .doc(companyId);

    const companyInChallengRef = admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companySizeCategory)
        .doc(companyId);

    await admin.firestore().runTransaction(async (t) => {
        const userInfo = await t.get(userRef);

        if (userInfo.exists) {
            userInfoData = userInfo.data();
        } else {
            throw new Error(Constant.userNotFoundError);
        }

        if (
            userInfoData.listChallengeIdRegister &&
            userInfoData.listChallengeIdRegister.includes(challengeId)
        ) {
            throw new Error(Constant.userAlreadyRegisteredError);
        }

        const userInChallengeInfo = await t.get(userInChallengeRef);
        if (userInChallengeInfo.exists) {
            throw new Error(Constant.userAlreadyRegisteredError);
        }

        if (
            !userInfoData.connectedEmail ||
            !userInfoData.connectedEmail.length ||
            !userInfoData.connectedEmail.find((x) => x.email == businessEmail)
        ) {
            throw new Error(Constant.businessEmailNotConnectedError);
        }

        if (
            !userInfoData.connectedEmail.find((x) => x.email == businessEmail)
                .verified
        ) {
            throw new Error(Constant.businessEmailNotVerifiedError);
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

        const businessEmailInChallenge = await t.get(
            challengeRef
                .collection(Constant.usersCollectionName)
                .where('businessEmail', '==', businessEmail)
                .limit(1)
        );
        if (!businessEmailInChallenge.empty) {
            throw new Error(Constant.userAlreadyRegisteredError);
        }

        if (isCyclist) {
            const companyInChallengInfo = await t.get(companyInChallengRef);
            if (!companyInChallengInfo.exists) {
                throw new Error(Constant.companyInChallengNotFoundError);
            }

            const companyInfo = await t.get(companyRef);
            if (companyInfo.exists) {
                companyInfoData = companyInfo.data();
            } else {
                throw new Error(Constant.companyNotFoundError);
            }

            if (
                !companyInfoData.listChallengeIdRegister ||
                !companyInfoData.listChallengeIdRegister.includes(challengeId)
            ) {
                throw new Error(Constant.companyNotRegisteredError);
            }

            if (!companyInfoData.isVerified) {
                throw new Error(Constant.companyNotVerifiedError);
            }
        }

        if (isChampion) {
            const companyInChallengInfo = await t.get(companyInChallengRef);
            if (companyInChallengInfo.exists) {
                throw new Error(
                    Constant.companyInChallengAlreadyExistFoundError
                );
            }

            const dataCompany = {
                listChallengeIdRegister: admin.firestore.FieldValue.arrayUnion(
                    ...[challengeId]
                ),
                companySizeCategory: companySizeCategory,
            };
            const companyInfo = await t.get(companyRef);
            if (companyInfo.exists) {
                t.update(userRef, dataCompany, { merge: true });
            } else {
                t.set(
                    companyRef,
                    { ...companyToAdd, ...dataCompany, isVerified: false },
                    { merge: false }
                );
            }

            const dataCompanyInChhalenge = {
                averageSpeed: 0,
                calorie: 0,
                co2: 0,
                distance: 0,
                maxSpeed: 0,
                steps: 0,
                rankingCo2: 0,
                rankingPercentRegistered: 0,
                percentRegistered: 0,
                companySizeCategory: companySizeCategory,
            };

            t.set(
                companyInChallengRef,
                { ...companyToAdd, ...dataCompanyInChhalenge },
                { merge: false }
            );

            if (
                companyToAdd.listDepartment &&
                companyToAdd.listDepartment.length
            ) {
                companyToAdd.listDepartment.forEach((department) => {
                    const departmentName = department.name;
                    const departmentId = department.id;
                    t.set(
                        companyInChallengRef
                            .collection(Constant.departmentCollectionName)
                            .doc(departmentName),
                        { ...companyToAdd, ...dataCompanyInChhalenge },
                        { merge: false }
                    );
                });
            }
        }
        const dataUserInChhalenge = {
            averageSpeed: 0,
            calorie: 0,
            co2: 0,
            distance: 0,
            maxSpeed: 0,
            steps: 0,
            rankingCo2: 0,
            alreadyStarted: false,
            companySizeCategory: companySizeCategory,
        };

        t.set(
            userInChallengeRef,
            { ...challengeRegistry, ...dataUserInChhalenge },
            { merge: false }
        );

        const dataUser = {
            listChallengeIdRegister: admin.firestore.FieldValue.arrayUnion(
                ...[challengeId]
            ),
        };

        if (businessEmail.includes('@mondora.com')) {
            dataUser.userType = 'mondora';
        }

        if (isFiabMember && fiabCardNumber) {
            dataUser.userType = 'fiab';
            dataUser.fiabCardNumber = fiabCardNumber;
        }
        t.update(userRef, dataUser, { merge: true });
        return;
    });
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
    companySizeCategory,
    documentId,
    newValue
) => {
    const data = {
        percentRegistered:
            (newValue.employeesNumberRegistered * 100) /
            newValue.employeesNumber,
        employeesNumberRegistered: newValue.employeesNumberRegistered,
    };

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companySizeCategory)
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
    lastCo2,
    pageSize
) => {
    let snapshot;
    if (lastCo2) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .orderBy('co2', 'desc')
            .startAfter(lastCo2)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(Constant.usersCollectionName)
            .orderBy('co2', 'desc')
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
    companySizeCategory,
    lastCo2,
    pageSize
) => {
    let snapshot;
    if (lastCo2) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companySizeCategory)
            .orderBy('co2', 'desc')
            .startAfter(lastCo2)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companySizeCategory)
            .orderBy('co2', 'desc')
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

const getListDepartmentClassificationByRankingCo2 = async (
    challengeId,
    companySizeCategory,
    companyId,
    lastCo2,
    pageSize
) => {
    let snapshot;
    if (lastCo2) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companySizeCategory)
            .doc(companyId)
            .collection(Constant.departmentCollectionName)
            .orderBy('co2', 'desc')
            .startAfter(lastCo2)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companySizeCategory)
            .doc(companyId)
            .collection(Constant.departmentCollectionName)
            .orderBy('co2', 'desc')
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
    companySizeCategory
) => {
    let snapshot;
    if (lastPercentRegistered) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companySizeCategory)
            .orderBy('percentRegistered', 'desc')
            .startAfter(lastPercentRegistered)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challengeId)
            .collection(companySizeCategory)
            .orderBy('percentRegistered', 'desc')
            .limit(pageSize)
            .get();
    }

    if (!snapshot.empty) {
        const list = [];
        for (let index = 0; index < snapshot.docs.length; index++) {
            const data = snapshot.docs[index].data();
            data.challengeId = challengeId;
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
        const data = challengeInfo.data();
        data.challengeId = challengeId;
        //TODO get ranking from tree algorithm
        data.rankingCo2 = 0;
        return data;
    } else {
        throw new Error(Constant.cyclistClassificationNotFoundError);
    }
};

const getUserDepartmentClassification = async (
    challengeId,
    companyId,
    companySizeCategory,
    departmentName
) => {
    const challengeInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companySizeCategory)
        .doc(companyId)
        .collection(Constant.departmentCollectionName)
        .doc(departmentName)
        .get();

    if (challengeInfo.exists) {
        const data = challengeInfo.data();
        data.challengeId = challengeId;
        data.name = departmentName;
        //TODO get ranking from tree algorithm
        data.rankingCo2 = 0;
        data.rankingPercentRegistered = 0;
        return data;
    } else {
        throw new Error(Constant.companyClassificationNotFoundError);
    }
};

const getUserCompanyClassification = async (
    challengeId,
    companyId,
    companySizeCategory
) => {
    const challengeInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(companySizeCategory)
        .doc(companyId)
        .get();

    if (challengeInfo.exists) {
        const data = challengeInfo.data();
        data.challengeId = challengeId;
        //TODO get ranking from tree algorithm
        data.rankingCo2 = 0;
        data.rankingPercentRegistered = 0;
        return data;
    } else {
        throw new Error(Constant.companyClassificationNotFoundError);
    }

    // const challengeCompanyInfo = await admin
    //     .firestore()
    //     .collection(Constant.challengeCollectionName)
    //     .doc(challengeId)
    //     .collection(Constant.companyCollectionName)
    //     .doc(companyId)
    //     .get();

    // if (challengeCompanyInfo.exists) {
    //     const data = challengeCompanyInfo.data();
    //     const companyCollectionForSizeCategory =
    //         Constant.getCompanyCollectionForSizeCategory(data.employeesNumber);

    //     const challengeCompanyForSizeCategoryInfo = await admin
    //         .firestore()
    //         .collection(Constant.challengeCollectionName)
    //         .doc(challengeId)
    //         .collection(companyCollectionForSizeCategory)
    //         .doc(companyId)
    //         .get();

    //     if (challengeCompanyForSizeCategoryInfo.exists) {
    //         const dataCompanyForSizeCategory =
    //             challengeCompanyForSizeCategoryInfo.data();

    //         return {
    //             ...data,
    //             rankingPercentRegistered:
    //                 dataCompanyForSizeCategory.rankingPercentRegistered,
    //         };
    //     } else {
    //         throw new Error(Constant.companuClassificationNotFoundError);
    //     }
    // } else {
    //     throw new Error(Constant.companuClassificationNotFoundError);
    // }
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
    getListDepartmentClassificationByRankingCo2,
    getListCyclistClassificationByRankingCo2,
    getListCompanyClassificationByRankingCo2,
    getListCompanyClassificationByRankingPercentRegistered,
    getUserCyclistClassification,
    getUserCompanyClassification,
    getUserDepartmentClassification,
    updateCompanyPercentRegistered,
    getChallengeRegistryFromBusinessEmail,
};
