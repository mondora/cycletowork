const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');

const saveSurvey = async (uid, challengeId, survey) => {
    await admin
        .firestore()
        .collection(Constant.challengeCollectionName)
        .doc(challengeId)
        .collection(Constant.surveyCollectionName)
        .doc(uid)
        .set(survey, { merge: false });
};

module.exports = {
    saveSurvey,
};
