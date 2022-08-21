const appRegion = ['europe-west3'];

const usersCollectionName = 'users';

const UserType = {
    Other: 'other',
    Mondora: 'mondora',
    Fiab: 'fiab',
};

const permissionDeniedMessage = 'permission-denied';

const setAdminUserErrorMessage = 'admin-user-error';

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

    static get setAdminUserErrorMessage() {
        return setAdminUserErrorMessage;
    }

    static get UserType() {
        return UserType;
    }
}

module.exports = { Constant };
