const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');

const saveSurveyResponse = async (challenge, surveyResponse) => {
    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challenge.id)
        .collection(Constant.surveyCollectionName)
        .doc(surveyResponse.id)
        .set(surveyResponse, { merge: false });
};

module.exports = {
    saveSurveyResponse,
};
