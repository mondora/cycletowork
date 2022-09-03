const admin = require('firebase-admin');
const { Constant } = require('../../../utility/constant');

const updateCompany = async (company) => {
    await admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .doc(company.id)
        .update(company, { merge: true });
};

const verifyCompany = async (company) => {
    company.isVerified = true;

    await admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .doc(company.id)
        .update(company, { merge: true });
};

module.exports = {
    updateCompany,
    verifyCompany,
};
