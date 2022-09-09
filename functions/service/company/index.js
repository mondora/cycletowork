const admin = require('firebase-admin');
const { Constant } = require('../../utility/constant');
const { elasticSearch } = require('../../utility/elastic_search');

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

const getCompanyListNameSearch = async (name) => {
    const searchResult = await elasticSearch.search({
        index: Constant.companyCollectionName,
        body: {
            query: {
                query_string: {
                    query: `*${name}*`,
                    fields: ['name'],
                },
            },
        },
    });
    const hits = searchResult.body.hits.hits;
    return hits.map((hit) => hit['_source']);
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

module.exports = {
    saveCompany,
    getCompanyListNameSearch,
    getCompanyList,
    getCompanyFromName,
};
