const admin = require('firebase-admin');
const { Constant } = require('../../../utility/constant');

const saveChallenge = async (challenge) => {
    const challengeInfo = await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .where('name', '==', challenge.name)
        .get();

    if (!challengeInfo.exists) {
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
};

module.exports = {
    saveChallenge,
    getChallengeList,
    publishChallenge,
};
