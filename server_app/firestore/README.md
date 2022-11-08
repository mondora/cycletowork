# Server app - Firestore

Used as NoSQL cloud database to store and sync data for client- and server-side development. Please read this [doc](../README.md) before.

## Set Cloud Firestore Security Rules

In [firestore.rules](./firestore.rules) can define [Cloud Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started).

## Manage indexes in Cloud Firestore

In [firestore.indexes.json](./firestore.indexes.json) can [Manage indexes in Cloud Firestore](https://firebase.google.com/docs/firestore/query-data/indexing) to ensures query performance by requiring an index for every query.

## Test

Please read this [doc](https://firebase.google.com/docs/firestore/security/get-started#testing_rules) for test.

## Deploy

Can deploy:

-   Cloud Firestore Security Rules and Manage indexes in Cloud Firestore by running the following command: `firebase deploy --only firestore`
-   Cloud Firestore Security Rules by running the following command: `firebase deploy --only firestore:rules`
-   Manage indexes in Cloud Firestore by running the following command: `firebase deploy --only firestore:indexes`
