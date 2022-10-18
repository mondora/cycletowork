const appRegion = ['europe-west3'];

const usersCollectionName = 'users';

const userActivityCollectionName = 'userActivity';

const userActivitySummaryCollectionName = 'userActivitySummary';

const challengeCollectionName = 'challenges';

const surveyCollectionName = 'surveys';

const companyCollectionName = 'companies';

const departmentCollectionName = 'departments';

const microCompanyCollectionName = 'microCompanies';

const smallCompanyCollectionName = 'smallCompanies';

const mediumCompanyCollectionName = 'mediumCompanies';

const largeCompanyCollectionName = 'largeCompanies';

const fcmCollectionName = 'fcm';

const deleteDocsCollectionName = 'deleteDocs';

const UserType = {
    Other: 'other',
    Mondora: 'mondora',
    Fiab: 'fiab',
};

const CompanySizeCategory = {
    micro: 'micro',
    small: 'small',
    medium: 'medium',
    large: 'large',
};

const permissionDeniedMessage = 'permission-denied';

const badRequestDeniedMessage = 'invalid-argument';

const unknownErrorMessage = 'unknown';

const userNotFoundError = 'user-not-found';

const codeIsExpired = 'code-is-expired';

const codeIsNotValid = 'code-is-not-valid';

const userAlreadyRegisteredError = 'user-already-registered';

const companyAlreadyExists = 'company-already-exists';

const surveyAlreadyExists = 'survey-already-exists';

const challengeAlreadyExists = 'challenge-already-exists';

const userNotRegisteredForChallengeError = 'user-not-registered-for-challenge';

class Constant {
    static get appRegion() {
        return appRegion;
    }

    static get usersCollectionName() {
        return usersCollectionName;
    }

    static get permissionDeniedMessage() {
        return permissionDeniedMessage;
    }

    static get badRequestDeniedMessage() {
        return badRequestDeniedMessage;
    }

    static get unknownErrorMessage() {
        return unknownErrorMessage;
    }

    static get UserType() {
        return UserType;
    }

    static get userNotFoundError() {
        return userNotFoundError;
    }

    static get userActivitySummaryCollectionName() {
        return userActivitySummaryCollectionName;
    }

    static get userActivityCollectionName() {
        return userActivityCollectionName;
    }

    static get deleteDocsCollectionName() {
        return deleteDocsCollectionName;
    }

    static get challengeCollectionName() {
        return challengeCollectionName;
    }

    static get surveyCollectionName() {
        return surveyCollectionName;
    }

    static get companyCollectionName() {
        return companyCollectionName;
    }

    static get companyAlreadyExists() {
        return companyAlreadyExists;
    }

    static get surveyAlreadyExists() {
        return surveyAlreadyExists;
    }

    static get challengeAlreadyExists() {
        return challengeAlreadyExists;
    }

    static get codeIsExpired() {
        return codeIsExpired;
    }

    static get codeIsNotValid() {
        return codeIsNotValid;
    }

    static get userAlreadyRegisteredError() {
        return userAlreadyRegisteredError;
    }

    static get userNotRegisteredForChallengeError() {
        return userNotRegisteredForChallengeError;
    }

    static get fcmCollectionName() {
        return fcmCollectionName;
    }

    static getCompanySizeCategory(employeesNumber) {
        if (employeesNumber < 10) {
            return CompanySizeCategory.micro;
        }

        if (employeesNumber < 50) {
            return CompanySizeCategory.small;
        }

        if (employeesNumber < 250) {
            return CompanySizeCategory.medium;
        }

        return CompanySizeCategory.large;
    }

    static getCompanyCollectionForSizeCategory(employeesNumber) {
        if (employeesNumber < 10) {
            return microCompanyCollectionName;
        }

        if (employeesNumber < 50) {
            return smallCompanyCollectionName;
        }

        if (employeesNumber < 250) {
            return mediumCompanyCollectionName;
        }

        return largeCompanyCollectionName;
    }

    static get microCompanyCollectionName() {
        return microCompanyCollectionName;
    }

    static get smallCompanyCollectionName() {
        return smallCompanyCollectionName;
    }

    static get mediumCompanyCollectionName() {
        return mediumCompanyCollectionName;
    }

    static get largeCompanyCollectionName() {
        return largeCompanyCollectionName;
    }

    static get departmentCollectionName() {
        return departmentCollectionName;
    }
}

module.exports = { Constant };
