# Server app - Functions

Used as serverless framework that lets you automatically run backend code in response to events triggered by Firebase features and HTTPS requests. Please read this [doc](../README.md) before.

## Function type

This app have tree functions type:

2.  [Authenticated](https://firebase.google.com/docs/functions/callable) (Normal and Admin)
3.  [Triggers](https://firebase.google.com/docs/functions/firestore-events)
4.  [Schedule](https://firebase.google.com/docs/functions/schedule-functions)

## Test

Please read this [doc](https://firebase.google.com/docs/functions/local-emulator) for test.

## Deploy

Can deploy:

-   All functions by running the following command: `firebase deploy --only functions`
-   Specific functions by running the following command: `firebase deploy --only functions:[function - name]`
