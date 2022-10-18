const admin = require('firebase-admin');
const { Constant } = require('../../../utility/constant');
const { getListUserAdmin } = require('../../admin/user');
const { getUserInfo } = require('../../user');
const { sendNotification, getListDeviceToken } = require('../../notification');
const { getString } = require('../../../localization');
const { loggerError } = require('../../../utility/logger');

const saveChallenge = async (challenge) => {
    const challengeInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .where('name', '==', challenge.name)
        .get();

    if (challengeInfo.empty) {
        await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .doc(challenge.id)
            .set(challenge, { merge: false });
    } else {
        throw new Error(Constant.challengeAlreadyExists);
    }
};

const getChallengeList = async (lastChallengeName, pageSize = 100) => {
    let snapshot;
    if (lastChallengeName) {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .orderBy('name')
            .startAfter(lastChallengeName)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.challengeCollectionName)
            .orderBy('name')
            .limit(pageSize)
            .get();
    }

    if (!snapshot.empty) {
        return snapshot.docs.map((doc) => doc.data());
    } else {
        return [];
    }
};

const publishChallenge = async (challenge) => {
    challenge.published = true;

    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challenge.id)
        .update(challenge, { merge: true });

    if (!challenge.sendNotification) {
        return;
    }

    if (
        challenge.isWhitelisted &&
        challenge.listUserUid &&
        challenge.listUserUid.length
    ) {
        for (let index = 0; index < challenge.listUserUid.length; index++) {
            const userUid = challenge.listUserUid[index];

            const user = await getUserInfo(userUid);
            const listDeviceToken = await getListDeviceToken(userUid);
            if (user && listDeviceToken && listDeviceToken.length) {
                await sendNotificationToUser(user, listDeviceToken);
            }
        }
        return;
    }

    let sentToAllUser = false;
    let nextPageToken;
    const UserSlot = 1000;
    while (!sentToAllUser) {
        try {
            const result = await getListUserAdmin(nextPageToken, UserSlot);

            if (result) {
                if (result.pagination && result.pagination.hasNextPage) {
                    nextPageToken = result.pagination.nextPageToken;
                } else {
                    sentToAllUser = true;
                }

                const allUserSlot = result.users;
                for (let index = 0; index < allUserSlot.length; index++) {
                    const userUid = allUserSlot[index].uid;

                    const user = await getUserInfo(userUid);
                    const listDeviceToken = await getListDeviceToken(userUid);
                    if (user && listDeviceToken && listDeviceToken.length) {
                        await sendNotificationToUser(user, listDeviceToken);
                    }
                }
            }
        } catch (error) {
            loggerError(
                'publishChallengeAdmin SendNotification Error, UID:',
                adminUid,
                'error:',
                error
            );
            sentToAllUser = true;
        }
    }
};

const sendNotificationToUser = async (user, listDeviceToken) => {
    const language = user.language;
    const title = getString(language, 'new_challenge_opened');
    const signUpNow = getString(language, 'sign_up_now');
    const description = `${signUpNow} ${
        user.displayName ? user.displayName : '!'
    }`;

    const data = {
        type: 'new_challenge',
    };

    await sendNotification(listDeviceToken, title, description, data);
};

module.exports = {
    saveChallenge,
    getChallengeList,
    publishChallenge,
};
