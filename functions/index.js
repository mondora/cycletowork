const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Constant } = require('./utility/constant');
const {
    createUser,
    deleteUser,
    setAdminUser,
    saveDeviceToken,
} = require('./service/user');

admin.initializeApp();

exports.helloWorld = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        return 'Hello from Firebase!';
    });

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

exports.setAdminUser = functions
    .region(Constant.appRegion)
    .https.onCall(async (data, context) => {
        const uid = context.auth.uid;

        if (uid) {
            try {
                await setAdminUser(uid);
                return true;
            } catch (error) {
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
