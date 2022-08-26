const admin = require('firebase-admin');
const { loggerLog } = require('../../utility/logger');

const sendNotification = async (deviceTokens, title, description, data) => {
    const payload = {
        data: data || {},
        notification: {
            title: title,
            body: description,
        },
    };

    loggerLog(
        'sendNotification',
        'payload:',
        payload,
        'deviceTokens:',
        deviceTokens
    );

    return await admin.messaging().sendToDevice(deviceTokens, payload);
};

module.exports = {
    sendNotification,
};
