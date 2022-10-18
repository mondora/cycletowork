const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');
// const { elasticSearch } = require('../../utility/elastic_search');
const { loggerError } = require('../../utility/logger');

const saveCompany = async (company) => {
    const companyInfo = await admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .where('name', '==', company.name)
        .get();

    if (companyInfo.empty) {
        await admin
            .firestore()
            .collection(Constant.companyCollectionName)
            .doc(company.id)
            .set(company, { merge: false });
    } else {
        throw new Error(Constant.companyAlreadyExists);
    }
};

const getCompanyListNameSearchForChalleng = async (
    challengeId,
    name,
    pageSize = 20
) => {
    // try {
    //     const searchResult = await elasticSearch.search({
    //         index: Constant.companyCollectionName,
    //         body: {
    //             from: 0,
    //             size: pageSize,
    //             query: {
    //                 bool: {
    //                     must: [
    //                         {
    //                             term: {
    //                                 isVerified: true,
    //                             },
    //                         },
    //                         {
    //                             query_string: {
    //                                 query: `*${name}*`,
    //                                 fields: ['name'],
    //                             },
    //                         },
    //                         {
    //                             match: {
    //                                 listChallengeIdRegister: challengeId,
    //                             },
    //                         },
    //                     ],
    //                 },
    //             },
    //         },
    //     });
    //     const hits = searchResult.hits.hits;
    //     return hits.map((hit) => hit['_source']);
    // } catch (error) {
    //     loggerError('getCompanyListNameSearchForChalleng error error:', error);
    //     return [];
    // }
};

const getCompanyList = async (lastCompanyName, pageSize = 100) => {
    let snapshot;
    if (lastCompanyName) {
        snapshot = await admin
            .firestore()
            .collection(Constant.companyCollectionName)
            .orderBy('name')
            .startAfter(lastCompanyName)
            .limit(pageSize)
            .get();
    } else {
        snapshot = await admin
            .firestore()
            .collection(Constant.companyCollectionName)
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

const getCompanyFromName = async (companyName) => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .where('name', '==', companyName)
        .get();

    if (!snapshot.empty) {
        return snapshot.docs[0].data();
    } else {
        return null;
    }
};

const getCompanyFromNameInChallenge = async (challengeId, companyName) => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .where('name', '==', companyName)
        .where('listChallengeIdRegister', 'array-contains', challengeId)
        .limit(1)
        .get();

    if (!snapshot.empty) {
        return snapshot.docs[0].data();
    } else {
        return null;
    }
};

const getCompanyListForChallenge = async (challengeId, pageSize = 20) => {
    const snapshot = await admin
        .firestore()
        .collection(Constant.companyCollectionName)
        .orderBy('name')
        .where('isVerified', '==', true)
        .where('listChallengeIdRegister', 'array-contains', challengeId)
        .limit(pageSize)
        .get();

    if (!snapshot.empty) {
        return snapshot.docs.map((doc) => doc.data());
    } else {
        return [];
    }
};

module.exports = {
    saveCompany,
    getCompanyList,
    getCompanyFromName,
    getCompanyFromNameInChallenge,
    getCompanyListNameSearchForChalleng,
    getCompanyListForChallenge,
};
