const { Client } = require('@elastic/elasticsearch');

const ELASTIC_ID = functions.config().elastic.id;
const ELASTIC_USERNAME = functions.config().elastic.username;
const ELASTIC_PASSWORD = functions.config().elastic.password;

const elasticSearch = new Client({
    cloud: {
        id: ELASTIC_ID,
        username: ELASTIC_USERNAME,
        password: ELASTIC_PASSWORD,
    },
});

module.exports = {
    elasticSearch,
};
