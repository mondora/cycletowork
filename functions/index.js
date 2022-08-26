const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Constant } = require('./utility/constant');
const {
    createUser,
    deleteUser,
    saveDeviceToken,
    getUserInfo,
    updateUserInfo,
} = require('./service/user');
const {
    getListUserAdmin,
    checkAdminUser,
    setAdminUser,
    verifyUserAdmin,
} = require('./service/admin/user');
const { saveUserActivity } = require('./service/activity');
const { sendNotification } = require('./service/notification');
const { loggerError, loggerLog, loggerDebug } = require('./utility/logger');
const { getString } = require('./localization');

admin.initializeApp();

exports.onCreateUser = functions
    .region(Constant.appRegion)
    .auth.user()
    .onCreate(async (user) => {
        await createUser(user);
    });

exports.onDeleteUser = functions
    .region(Constant.appRegion)
    .auth.user()
    .onDelete(async (user) => {
        await deleteUser(user);
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

exports.saveUserActivity = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;
        const userActivitySummary = data.userActivitySummary;
        const userActivity = data.userActivity;
        if (uid) {
            if (!userActivitySummary || !userActivity) {
                throw new functions.https.HttpsError(
                    Constant.badRequestDeniedMessage
                );
            }
            try {
                await saveUserActivity(uid, userActivity, userActivitySummary);
                return true;
            } catch (error) {
                loggerError(
                    'saveUserActivity Error, UID:',
                    uid,
                    'userActivity:',
                    userActivity,
                    'userActivitySummary:',
                    userActivitySummary,
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
            if (user && user.deviceTokens && user.deviceTokens.length) {
                const language = user.language;
                const congratulation = getString(language, 'congratulation');
                const title = `${congratulation} ${
                    user.displayName ? user.displayName : ''
                }`;
                const description = getString(
                    language,
                    'you_have_become_admin'
                );
                await sendNotification(user.deviceTokens, title, description);
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
            if (user && user.deviceTokens && user.deviceTokens.length) {
                const language = user.language;
                const congratulation = getString(language, 'congratulation');
                const title = `${congratulation} ${
                    user.displayName ? user.displayName : ''
                }`;
                const description = getString(
                    language,
                    'you_have_been_verified'
                );
                await sendNotification(user.deviceTokens, title, description);
            }

            return true;
        } catch (error) {
            loggerError('verifyUserAdmin Error, UID:', uid, 'error:', error);
            throw new functions.https.HttpsError(Constant.unknownErrorMessage);
        }
    });

// exports.scheduledFunctionCrontab = functions
//     .region(Constant.appRegion)
//     .pubsub.schedule('1 0 * * *')
//     .timeZone('Europe/Berlin')
//     .onRun((context) => {
//         console.log('This will be run every day at 00:01 Europe/Berlin!');
//         return null;
//     });
