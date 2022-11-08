# Cycle2Work - Server app

Server app is Firebase an app development platform, that used:

-   [Cloud Functions](https://firebase.google.com/products/functions) as serverless framework that lets you automatically run backend code in response to events triggered by Firebase features and HTTPS requests.
-   [Cloud Firestore](https://firebase.google.com/docs/firestore) as NoSQL cloud database to store and sync data for client- and server-side development.
-   [Cloud Storage](https://firebase.google.com/docs/firestore) to store and serve user-generated content, such as photos or videos.

## Getting Started

-   Install the [Firebase CLI](https://firebase.google.com/docs/cli)

    1.  Install [Node.js](https://nodejs.org/en/) using [nvm-windows](https://github.com/coreybutler/nvm-windows) (the Node Version Manager). Installing Node.js automatically installs the npm command tools.
    2.  Install the Firebase CLI via npm by running the following command: `npm install -g firebase-tools`
    3.  Continue to log by running the following command: `firebase login`

-   [Initialize a Firebase project](https://firebase.google.com/docs/cli#initialize_a_firebase_project) by running the following command: `firebase init`
-   [Deploy to a Firebase project](https://firebase.google.com/docs/cli#deployment) by running the following command: `firebase deploy`

## Parts

-   [Functions](./functions/README.md)
-   [Firestore](./firestore/README.md)
-   [Storage](./storage/README.md)
