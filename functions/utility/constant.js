const appRegion = ['europe-west3'];

const usersCollectionName = 'users';

const userActivityCollectionName = 'userActivity';

const userActivitySummaryCollectionName = 'userActivitySummary';

const dataList = 'dataList';

const UserType = {
    Other: 'other',
    Mondora: 'mondora',
    Fiab: 'fiab',
};

const permissionDeniedMessage = 'permission-denied';

const badRequestDeniedMessage = 'invalid-argument';

const unknownErrorMessage = 'unknown';

const userNotFoundError = 'user-not-found';

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

    static get dataList() {
        return dataList;
    }
}

module.exports = { Constant };
