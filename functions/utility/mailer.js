const nodemailer = require('nodemailer');

const MAILER_EMAIL = functions.config().mailer.email;
const MAILER_PASSWORD = functions.config().mailer.password;

const miler = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    auth: {
        user: MAILER_EMAIL,
        pass: MAILER_PASSWORD,
    },
});

module.exports = {
    mailer,
};
