const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Constant } = require('./utility/constant');
const {
    createUser,
    deleteAccount,
    getUserInfo,
    updateUserInfo,
    sendEmailVerificationCode,
    verifiyEmailCode,
} = require('./service/user');
const {
    getListUserAdmin,
    checkAdminUser,
    setAdminUser,
    verifyUserAdmin,
} = require('./service/admin/user');
const {
    saveUserActivity,
    saveUserActivityLocationData,
    getListUserActivity,
} = require('./service/activity');
const {
    sendNotification,
    saveDeviceToken,
    removeDeviceToken,
    getListDeviceToken,
} = require('./service/notification');
const { loggerError, loggerLog, loggerDebug } = require('./utility/logger');
const { getString } = require('./localization');
const {
    saveCompany,
    getCompanyListNameSearchForChalleng,
    getCompanyList,
    getCompanyFromName,
    getCompanyListForChallenge,
    getCompanyFromNameInChallenge,
} = require('./service/company');
const { updateCompany, verifyCompany } = require('./service/admin/company');
const { saveSurveyResponse } = require('./service/survey');
const { saveSurvey, getSurveyList } = require('./service/admin/survey');
const {
    saveChallenge,
    getChallengeList,
    publishChallenge,
} = require('./service/admin/challenge');
const {
    getActiveChallengeList,
    registerChallenge,
    getListActiveRegisterdChallenge,
    getListRegisterdChallenge,
    getListDepartmentClassificationByRankingCo2,
    getListCyclistClassificationByRankingCo2,
    getListCompanyClassificationByRankingCo2,
    getListCompanyClassificationByRankingPercentRegistered,
    getUserCyclistClassification,
    getUserCompanyClassification,
    getUserDepartmentClassification,
    getChallengeRegistryFromBusinessEmail,
    updateCompanyPercentRegistered,
    updateUserInfoInChallenge,
} = require('./service/challenge');
const { recursiveDeleteDocs } = require('./service/core');

admin.initializeApp();

exports.onCreateUser = functions
    .region(Constant.appRegion)
    .runWith({
        minInstances: 2,
    })
    .auth.user()
    .onCreate(async (user) => {
        await createUser(user);
    });

exports.onCreateUserPhoto = functions
    .region(Constant.appRegion)
    .storage.object()
    .onFinalize(async (object) => {
        const uid = object.metadata.uid;
        const name = object.name;
        const dataUser = {
            listFile: admin.firestore.FieldValue.arrayUnion(...[name]),
        };
        await admin
            .firestore()
            .collection(Constant.usersCollectionName)
            .doc(uid)
            .update(dataUser, { merge: true });
    });

exports.scheduledFunction = functions
    .region(Constant.appRegion)
    .runWith({
        timeoutSeconds: 540,
        memory: '2GB',
    })
    .pubsub.schedule('every 15 minutes')
    .onRun(async (context) => {
        await recursiveDeleteDocs();
    });

exports.updateCompanyPercentRegistered = functions
    .region(Constant.appRegion)
    .firestore.document(
        `${Constant.challengeCollectionName}/{challengeId}/{companySizeCategory}/{documentId}`
    )
    .onUpdate((change, context) => {
        const challengeId = context.params.challengeId;
        const companySizeCategory = context.params.companySizeCategory;
        const documentId = context.params.documentId;

        const newValue = change.after.data();
        const previousValue = change.before.data();

        if (
            newValue.employeesNumberRegistered !=
            previousValue.employeesNumberRegistered
        ) {
            updateCompanyPercentRegistered(
                challengeId,
                companySizeCategory,
                documentId,
                newValue
            );
        }
    });

exports.deleteAccount = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            try {
                await deleteAccount(uid);
                return true;
            } catch (error) {
                loggerError('deleteAccount Error, UID:', uid, 'error:', error);
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveDeviceToken = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const deviceToken = data.deviceToken;
        if (uid) {
            if (!deviceToken || deviceToken == '') {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await saveDeviceToken(uid, deviceToken);
                return true;
            } catch (error) {
                loggerError(
                    'saveDeviceToken Error, UID:',
                    uid,
                    'deviceToken:',
                    deviceToken,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.removeDeviceToken = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const deviceToken = data.deviceToken;
        if (uid) {
            if (!deviceToken || deviceToken == '') {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await removeDeviceToken(deviceToken);
                return true;
            } catch (error) {
                loggerError(
                    'removeDeviceToken Error, UID:',
                    uid,
                    'deviceToken:',
                    deviceToken,
                    'error:',
                    error
                );
                // throw new functions.https.HttpsError(
                //     Constant.unknownErrorMessage
                // );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getUserInfo = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            try {
                return await getUserInfo(uid);
            } catch (error) {
                loggerError('getUserInfo Error, UID:', uid, 'error:', error);
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveCompany = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const company = data.company;
        if (uid) {
            if (!company) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            loggerLog('saveCompany UID:', uid, 'company:', company);
            try {
                await saveCompany(company);
                return true;
            } catch (error) {
                loggerError(
                    'saveCompany Error, UID:',
                    uid,
                    'company:',
                    company,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getCompanyListNameSearchForChalleng = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination || !data.challengeId || !data.name) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const challengeId = data.challengeId;
            const name = data.name;

            loggerLog(
                'getCompanyListNameSearchForChalleng UID:',
                uid,
                'data:',
                data
            );
            try {
                return await getCompanyListNameSearchForChalleng(
                    challengeId,
                    name,
                    pageSize
                );
            } catch (error) {
                loggerError(
                    'getCompanyListNameSearchForChalleng Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getCompanyFromName = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.companyName) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const companyName = data.companyName;

            loggerLog('getCompanyFromName UID:', uid, 'data:', data);
            try {
                return await getCompanyFromName(companyName);
            } catch (error) {
                loggerError(
                    'getCompanyFromName Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getCompanyFromNameInChallenge = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.companyName || !data.challengeId) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const companyName = data.companyName;

            loggerLog('getCompanyFromNameInChallenge UID:', uid, 'data:', data);
            try {
                return await getCompanyFromNameInChallenge(
                    challengeId,
                    companyName
                );
            } catch (error) {
                loggerError(
                    'getCompanyFromNameInChallenge Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getCompanyListForChallenge = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination || !data.challengeId) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const challengeId = data.challengeId;

            loggerLog('getCompanyListForChallenge UID:', uid, 'data:', data);
            try {
                return await getCompanyListForChallenge(challengeId, pageSize);
            } catch (error) {
                loggerError(
                    'getCompanyListForChallenge Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getCompanyList = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const lastCompanyName = data.pagination.lastCompanyName;

            loggerLog('getCompanyList UID:', uid, 'data:', data);
            try {
                return await getCompanyList(lastCompanyName, pageSize);
            } catch (error) {
                loggerError(
                    'getCompanyList Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getSurveyList = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const lastSurveyName = data.pagination.lastSurveyName;

            loggerLog('getSurveyList UID:', uid, 'data:', data);
            try {
                return await getSurveyList(lastSurveyName, pageSize);
            } catch (error) {
                loggerError(
                    'getSurveyList Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getActiveChallengeList = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            loggerLog('getActiveChallengeList UID:', uid, 'data: ', data);
            try {
                return await getActiveChallengeList(uid);
            } catch (error) {
                loggerError(
                    'getActiveChallengeList Error, UID:',
                    uid,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveSurveyResponse = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        if (uid) {
            if (!data) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                const challenge = data.challenge;
                const surveyResponse = data.surveyResponse;

                loggerLog('saveSurveyResponse, UID:', uid, 'data:', data);
                await saveSurveyResponse(challenge, surveyResponse);
                return true;
            } catch (error) {
                loggerError(
                    'saveSurveyResponse Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.sendEmailVerificationCode = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        if (uid) {
            if (!data || !data.email) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                const email = data.email.split(' ').join('').toLowerCase();
                const displayName = data.displayName;

                loggerLog(
                    'sendEmailVerificationCode, UID:',
                    uid,
                    'data:',
                    data
                );
                await sendEmailVerificationCode(uid, email, displayName);
                return true;
            } catch (error) {
                loggerError(
                    'sendEmailVerificationCode Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.verifiyEmailCode = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        if (uid) {
            if (!data) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                const email = data.email;
                const code = data.code;

                loggerLog('verifiyEmailCode, UID:', uid, 'data:', data);
                await verifiyEmailCode(uid, email, code);
                return true;
            } catch (error) {
                loggerError(
                    'verifiyEmailCode Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.registerChallenge = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        loggerLog('registerChallenge, UID:', uid, 'data:', data);
        if (uid) {
            if (!data) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                const challengeRegistry = data.challengeRegistry;

                loggerLog('registerChallenge, UID:', uid, 'data:', data);
                await registerChallenge(uid, challengeRegistry);
                return true;
            } catch (error) {
                loggerError(
                    'registerChallenge Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveUserActivity = functions
    .region(Constant.appRegion)
    .runWith({
        minInstances: 5,
    })
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const userActivity = data.userActivity;
        if (uid) {
            if (!userActivity) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await saveUserActivity(uid, userActivity);
                return true;
            } catch (error) {
                loggerError(
                    'saveUserActivity Error, UID:',
                    uid,
                    'userActivity:',
                    userActivity,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveUserActivityLocationData = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (
                !data.userActivity ||
                !data.listLocationData ||
                !data.listLocationDataUnFiltred
            ) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                const userActivity = data.userActivity;
                const listLocationData = data.listLocationData;
                const listLocationDataUnFiltred =
                    data.listLocationDataUnFiltred;

                await saveUserActivityLocationData(
                    uid,
                    userActivity,
                    listLocationData,
                    listLocationDataUnFiltred
                );
                return true;
            } catch (error) {
                loggerError(
                    'saveUserActivityLocationData Error, UID:',
                    uid,
                    'userActivity:',
                    data.userActivity,
                    'error:',
                    error
                );
                return {
                    success: false,
                    message: Constant.unknownErrorMessage,
                };
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListUserActivity = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const startDate = data.pagination.startDate;

            loggerLog('getListUserActivity UID:', uid, 'data:', data);
            try {
                return await getListUserActivity(uid, startDate, pageSize);
            } catch (error) {
                loggerError(
                    'getListUserActivity Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListActiveRegisterdChallenge = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            loggerLog(
                'getListActiveRegisterdChallenge UID:',
                uid,
                'data: ',
                data
            );
            try {
                return await getListActiveRegisterdChallenge(uid);
            } catch (error) {
                loggerError(
                    'getListActiveRegisterdChallenge Error, UID:',
                    uid,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListCyclistClassificationByRankingCo2 = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination || !data.challengeId) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const pageSize = data.pagination.pageSize;
            const lastCo2 = data.pagination.lastCo2;

            loggerLog(
                'getListCyclistClassificationByRankingCo2 UID:',
                uid,
                'challengeId:',
                challengeId,
                'data:',
                data
            );
            try {
                return await getListCyclistClassificationByRankingCo2(
                    challengeId,
                    lastCo2,
                    pageSize
                );
            } catch (error) {
                loggerError(
                    'getListCyclistClassificationByRankingCo2 Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListCompanyClassificationByRankingCo2 = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (
                !data ||
                !data.pagination ||
                !data.challengeId ||
                !data.companySizeCategory
            ) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const companySizeCategory = data.companySizeCategory;
            const pageSize = data.pagination.pageSize;
            const lastCo2 = data.pagination.lastCo2;

            loggerLog(
                'getListCompanyClassificationByRankingCo2 UID:',
                uid,
                'challengeId:',
                challengeId,
                'data:',
                data
            );
            try {
                return await getListCompanyClassificationByRankingCo2(
                    challengeId,
                    companySizeCategory,
                    lastCo2,
                    pageSize
                );
            } catch (error) {
                loggerError(
                    'getListCompanyClassificationByRankingCo2 Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListCompanyClassificationByRankingPercentRegistered = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (
                !data ||
                !data.pagination ||
                !data.challengeId ||
                !data.companySizeCategory
            ) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const companySizeCategory = data.companySizeCategory;
            const pageSize = data.pagination.pageSize;
            const lastPercentRegistered = data.pagination.lastPercentRegistered;

            loggerLog(
                'getListCompanyClassificationByRankingPercentRegistered UID:',
                uid,
                'challengeId:',
                challengeId,
                'companySizeCategory:',
                companySizeCategory,
                'data:',
                data
            );
            try {
                return await getListCompanyClassificationByRankingPercentRegistered(
                    challengeId,
                    lastPercentRegistered,
                    pageSize,
                    companySizeCategory
                );
            } catch (error) {
                loggerError(
                    'getListCompanyClassificationByRankingPercentRegistered Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'companySizeCategory:',
                    companySizeCategory,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListDepartmentClassificationByRankingCo2 = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (
                !data ||
                !data.pagination ||
                !data.challengeId ||
                !data.companySizeCategory ||
                !data.companyId
            ) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const companySizeCategory = data.companySizeCategory;
            const companyId = data.companyId;
            const pageSize = data.pagination.pageSize;
            const lastCo2 = data.pagination.lastCo2;

            loggerLog(
                'getListDepartmentClassificationByRankingCo2 UID:',
                uid,
                'challengeId:',
                challengeId,
                'companySizeCategory:',
                companySizeCategory,
                'data:',
                data
            );
            try {
                return await getListDepartmentClassificationByRankingCo2(
                    challengeId,
                    companySizeCategory,
                    companyId,
                    lastCo2,
                    pageSize
                );
            } catch (error) {
                loggerError(
                    'getListDepartmentClassificationByRankingCo2 Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'companySizeCategory:',
                    companySizeCategory,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getChallengeRegistryFromBusinessEmail = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.challengeId || !data.businessEmail) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const businessEmail = data.businessEmail;
            loggerLog(
                'getChallengeRegistryFromBusinessEmail UID:',
                uid,
                'challengeId:',
                challengeId,
                'data:',
                data
            );
            try {
                return await getChallengeRegistryFromBusinessEmail(
                    challengeId,
                    businessEmail
                );
            } catch (error) {
                loggerError(
                    'getChallengeRegistryFromBusinessEmail Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getUserCyclistClassification = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.challengeId) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            loggerLog(
                'getUserCyclistClassification UID:',
                uid,
                'challengeId:',
                challengeId,
                'data:',
                data
            );
            try {
                return await getUserCyclistClassification(challengeId, uid);
            } catch (error) {
                loggerError(
                    'getUserCyclistClassification Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getUserCompanyClassification = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (
                !data ||
                !data.challengeId ||
                !data.companyId ||
                !data.companySizeCategory
            ) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const companyId = data.companyId;
            const companySizeCategory = data.companySizeCategory;
            loggerLog(
                'getUserCompanyClassification UID:',
                uid,
                'challengeId:',
                challengeId,
                'data:',
                data
            );
            try {
                return await getUserCompanyClassification(
                    challengeId,
                    companyId,
                    companySizeCategory
                );
            } catch (error) {
                loggerError(
                    'getUserCompanyClassification Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getUserDepartmentClassification = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (
                !data ||
                !data.challengeId ||
                !data.companyId ||
                !data.companySizeCategory ||
                !data.departmentName
            ) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const challengeId = data.challengeId;
            const companyId = data.companyId;
            const companySizeCategory = data.companySizeCategory;
            const departmentName = data.departmentName;

            loggerLog(
                'getUserDepartmentClassification UID:',
                uid,
                'challengeId:',
                challengeId,
                'data:',
                data
            );
            try {
                return await getUserDepartmentClassification(
                    challengeId,
                    companyId,
                    companySizeCategory,
                    departmentName
                );
            } catch (error) {
                loggerError(
                    'getUserDepartmentClassification Error, UID:',
                    uid,
                    'challengeId:',
                    challengeId,
                    'data:',
                    data,
                    'error:',
                    error
                );
                return;
                // throw new functions.https.HttpsError(
                //     Constant.unknownErrorMessage
                // );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getListRegisterdChallenge = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            loggerLog('getListRegisterdChallenge UID:', uid, 'data: ', data);
            try {
                return await getListRegisterdChallenge(uid);
            } catch (error) {
                loggerError(
                    'getListRegisterdChallenge Error, UID:',
                    uid,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.updateUserInfo = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        if (uid) {
            if (!data) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                loggerLog('updateUserInfo, UID:', uid, 'data:', data);
                await updateUserInfo(uid, data);
                return true;
            } catch (error) {
                loggerError(
                    'updateUserInfo Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.updateUserInfoInChallenge = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        if (uid) {
            if (!data || !data.challengeId) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                loggerLog(
                    'updateUserInfoInChallenge, UID:',
                    uid,
                    'data:',
                    data
                );
                await updateUserInfoInChallenge(uid, data);
                return true;
            } catch (error) {
                loggerError(
                    'updateUserInfoInChallenge Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

// **** ADMIN FUNCTIONS **** //
exports.getListUserAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            if (!data || !data.pagination) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const nextPageToken = data.pagination.nextPageToken;

            try {
                loggerLog(
                    'getListUserAdmin, UID:',
                    uid,
                    'pageSize:',
                    pageSize,
                    'nextPageToken:',
                    nextPageToken,
                    'data.filter:',
                    data.filter
                );
                return await getListUserAdmin(
                    nextPageToken,
                    pageSize,
                    data.filter
                );
            } catch (error) {
                loggerError(
                    'getListUserAdmin Error, UID:',
                    uid,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getUserInfoAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const adminUid = context.auth.uid;
        const uid = data.uid;

        if (!adminUid) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
        loggerLog('getUserInfoAdmin UID:', uid, 'Admin UID:', adminUid);
        const isAdmin = await checkAdminUser(adminUid);
        if (!isAdmin) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }

        if (!uid || uid == '') {
            throw new functions.https.HttpsError(
                Constant.badRequestDeniedMessage
            );
        }

        try {
            return await getUserInfo(uid);
        } catch (error) {
            loggerError('getUserInfoAdmin Error, UID:', uid, 'error:', error);
            throw new functions.https.HttpsError(Constant.unknownErrorMessage);
        }
    });

exports.setAdminUser = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const adminUid = context.auth.uid;
        const uid = data.uid;

        if (!adminUid) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
        loggerLog('setAdminUser UID:', uid, 'Admin UID:', adminUid);
        const isAdmin = await checkAdminUser(adminUid);
        if (!isAdmin) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }

        if (!uid || uid == '') {
            throw new functions.https.HttpsError(
                Constant.badRequestDeniedMessage
            );
        }

        try {
            await setAdminUser(uid);

            const user = await getUserInfo(uid);
            const listDeviceToken = await getListDeviceToken(uid);
            if (user && listDeviceToken && listDeviceToken.length) {
                const language = user.language;
                const congratulation = getString(language, 'congratulation');
                const title = `${congratulation} ${
                    user.displayName ? user.displayName : ''
                }`;
                const description = getString(
                    language,
                    'you_have_become_admin'
                );

                await sendNotification(listDeviceToken, title, description);
            }

            return true;
        } catch (error) {
            loggerError('setAdminUser Error, UID:', uid, 'error:', error);
            throw new functions.https.HttpsError(Constant.unknownErrorMessage);
        }
    });

exports.verifyUserAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const adminUid = context.auth.uid;
        const uid = data.uid;

        if (!adminUid) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
        loggerLog('verifyUserAdmin UID:', uid, 'Admin UID:', adminUid);
        const isAdmin = await checkAdminUser(adminUid);
        if (!isAdmin) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }

        if (!uid || uid == '') {
            throw new functions.https.HttpsError(
                Constant.badRequestDeniedMessage
            );
        }

        try {
            await verifyUserAdmin(uid);

            const user = await getUserInfo(uid);
            const listDeviceToken = await getListDeviceToken(uid);
            if (user && listDeviceToken && listDeviceToken.length) {
                const language = user.language;
                const congratulation = getString(language, 'congratulation');
                const title = `${congratulation} ${
                    user.displayName ? user.displayName : ''
                }`;
                const description = getString(
                    language,
                    'you_have_been_verified'
                );

                await sendNotification(listDeviceToken, title, description);
            }

            return true;
        } catch (error) {
            loggerError('verifyUserAdmin Error, UID:', uid, 'error:', error);
            throw new functions.https.HttpsError(Constant.unknownErrorMessage);
        }
    });

exports.verifyCompanyAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const adminUid = context.auth.uid;
        const company = data.company;

        if (!adminUid) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
        loggerLog('verifyCompanyAdmin Admin UID:', adminUid, 'data:', data);
        const isAdmin = await checkAdminUser(adminUid);
        if (!isAdmin) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }

        if (!company || company == '') {
            throw new functions.https.HttpsError(
                Constant.badRequestDeniedMessage
            );
        }

        try {
            await verifyCompany(company);

            if (!company.registerUserUid) {
                return true;
            }

            const user = await getUserInfo(company.registerUserUid);
            const listDeviceToken = await getListDeviceToken(
                company.registerUserUid
            );
            if (user && listDeviceToken && listDeviceToken.length) {
                const language = user.language;
                const congratulation = getString(language, 'congratulation');
                const title = `${congratulation} ${
                    user.displayName ? user.displayName : ''
                }`;
                const theCompany = getString(language, 'the_company');
                const hasBeenVerified = getString(
                    language,
                    'has_been_verified_for_company'
                );
                const description = `${theCompany} ${
                    company.name
                } ${hasBeenVerified.toLowerCase()}`;

                await sendNotification(listDeviceToken, title, description);
            }

            return true;
        } catch (error) {
            loggerError(
                'verifyCompanyAdmin Error, UID:',
                adminUid,
                'data:',
                data,
                'error:',
                error
            );
            throw new functions.https.HttpsError(Constant.unknownErrorMessage);
        }
    });

exports.updateCompanyAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const company = data.company;
        if (uid) {
            loggerLog('updateCompanyAdmin UID:', uid, 'company:', company);
            const isAdmin = await checkAdminUser(uid);
            if (!isAdmin) {
                throw new functions.https.HttpsError(
                    Constant.permissionDeniedMessage
                );
            }
            if (!company) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await updateCompany(company);
                return true;
            } catch (error) {
                loggerError(
                    'updateCompanyAdmin Error, UID:',
                    uid,
                    'company:',
                    company,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveSurveyAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const survey = data.survey;
        if (uid) {
            loggerLog('saveSurveyAdmin UID:', uid, 'survey:', survey);
            const isAdmin = await checkAdminUser(uid);
            if (!isAdmin) {
                throw new functions.https.HttpsError(
                    Constant.permissionDeniedMessage
                );
            }
            if (!survey) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await saveSurvey(survey);
                return true;
            } catch (error) {
                loggerError(
                    'saveSurveyAdmin Error, UID:',
                    uid,
                    'survey:',
                    survey,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.saveChallengeAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const challenge = data.challenge;
        if (uid) {
            loggerLog('saveChallengeAdmin UID:', uid, 'challenge:', challenge);
            const isAdmin = await checkAdminUser(uid);
            if (!isAdmin) {
                throw new functions.https.HttpsError(
                    Constant.permissionDeniedMessage
                );
            }
            if (!challenge) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await saveChallenge(challenge);
                return true;
            } catch (error) {
                loggerError(
                    'saveChallengeAdmin Error, UID:',
                    uid,
                    'challenge:',
                    challenge,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.getChallengeListAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            const isAdmin = await checkAdminUser(uid);
            if (!isAdmin) {
                throw new functions.https.HttpsError(
                    Constant.permissionDeniedMessage
                );
            }

            if (!data || !data.pagination) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }

            const pageSize = data.pagination.pageSize;
            const lastChallengeName = data.pagination.lastChallengeName;

            loggerLog('getChallengeListAdmin UID:', uid, 'data:', data);
            try {
                return await getChallengeList(lastChallengeName, pageSize);
            } catch (error) {
                loggerError(
                    'getChallengeListAdmin Error, UID:',
                    uid,
                    'data:',
                    data,
                    'error:',
                    error
                );
                throw new functions.https.HttpsError(
                    Constant.unknownErrorMessage
                );
            }
        } else {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
    });

exports.publishChallengeAdmin = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const adminUid = context.auth.uid;
        const challenge = data.challenge;

        if (!adminUid) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }
        loggerLog(
            'publishChallengeAdmin UID:',
            adminUid,
            'challenge:',
            challenge
        );
        const isAdmin = await checkAdminUser(adminUid);
        if (!isAdmin) {
            throw new functions.https.HttpsError(
                Constant.permissionDeniedMessage
            );
        }

        if (!challenge || !challenge.id) {
            throw new functions.https.HttpsError(
                Constant.badRequestDeniedMessage
            );
        }

        try {
            await publishChallenge(challenge);
            return true;
        } catch (error) {
            loggerError(
                'publishChallengeAdmin Error, UID:',
                adminUid,
                'error:',
                error
            );
            throw new functions.https.HttpsError(Constant.unknownErrorMessage);
        }
    });
