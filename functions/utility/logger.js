const functions = require('firebase-functions');

const loggerError = (...messages) => {
    functions.logger.error(messages);
};

const loggerDebug = (...messages) => {
    functions.logger.debug(messages);
};

const loggerLog = (...messages) => {
    functions.logger.log(messages);
};

const loggerInfo = (...messages) => {
    functions.logger.info(messages);
};

const loggerWarning = (...messages) => {
    functions.logger.warn(messages);
};

module.exports = {
    loggerError,
    loggerDebug,
    loggerLog,
    loggerInfo,
    loggerWarning,
};
