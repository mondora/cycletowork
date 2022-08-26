const it = require('./it.json');
const { loggerError } = require('../utility/logger');

const getString = (lang, key, translate = false) => {
    try {
        let file;
        switch (lang || 'it') {
            case 'it':
                file = it;
                break;

            default:
                file = it;
        }

        return file[key];
    } catch (error) {
        loggerError(
            'getString localization Error, key:',
            key,
            'translate:',
            translate,
            'error:',
            error
        );
    }
};

module.exports = {
    getString,
};
