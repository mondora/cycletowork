const functions = require('firebase-functions');

// firebase functions:config:set sendgrid.api_key="API_KEY"
const SENDGRID_API_KEY = functions.config().sendgrid.api_key;

const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(SENDGRID_API_KEY);

module.exports = {
    sgMail,
};
