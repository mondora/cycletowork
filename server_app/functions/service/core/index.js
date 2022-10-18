const admin = require('firebase-admin');
const firebase_tools = require('firebase-tools');
const functions = require('firebase-functions');
const { Constant } = require('../../utility/constant');
const { loggerDebug, loggerError } = require('../../utility/logger');

// firebase functions:config:set fb.token="TOKEN"
const FB_TOKEN = functions.config().fb.token;

const recursiveDeleteDocs = async () => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.deleteDocsCollectionName)
        .orderBy('requestDate', 'asc')
        .where('isDone', '==', false)
        .limit(1)
        .get();

    if (snapshot.empty) {
        return;
    }
    const data = snapshot.docs[0].data();
    const id = data.id;
    const path = data.path;
    const isStorageFile = data.isStorageFile;

    if (isStorageFile) {
        await admin.storage().bucket().file(path).delete();
    } else {
        await firebase_tools.firestore.delete(path, {
            project: process.env.GCLOUD_PROJECT,
            recursive: true,
            force: true,
            token: FB_TOKEN,
        });
    }

    await admin
        .firestore()
        .collection(Constant.deleteDocsCollectionName)
        .doc(id)
        .update({ isDone: true }, { merge: true });
};

module.exports = {
    recursiveDeleteDocs,
};
