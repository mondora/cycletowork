const admin = require('firebase-admin');
const { Constant } = require('../../../utility/constant');

const saveSurvey = async (survey) => {
    const surveyInfo = await admin
        .firestore()
        .collection(Constant.surveyCollectionName)
        .where('name', '==', survey.name)
        .get();

    if (surveyInfo.empty) {
        await admin
            .firestore()
            .collection(Constant.surveyCollectionName)
            .doc(survey.id)
            .set(survey, { merge: false });
    } else {
        throw new Error(Constant.surveyAlreadyExists);
    }
};

const getSurveyList = async (lastSurveyName, pageSize = 100) => {
    let snapshot;
    if (lastSurveyName) {
        snapshot = await admin
            .firestore()
            .collection(Constant.surveyCollectionName)
            .orderBy('name')
            .startAfter(lastSurveyName)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.surveyCollectionName)
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

module.exports = {
    saveSurvey,
    getSurveyList,
};
