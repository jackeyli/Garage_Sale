const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const ITEM_STATUS_BOOKED = 'Booked';
const ITEM_STATUS_POSTED = 'Posted';
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
exports.notifiySeller = functions.firestore.document('PostedItems/{PostedItemId}').onUpdate(async(Change, context) => {
    console.log(Change.before.data());
    console.log(Change.after.data());
    console.log(context.params.PostedItemId);
    let before = Change.before.data(),
        after = Change.after.data();
    if(before['status'] === ITEM_STATUS_POSTED && after['status'] === ITEM_STATUS_BOOKED){
        console.log('Push Message');
        await admin.messaging().sendToTopic(before.seller,{
            notification:{
               title:"Your Item has been booked",
               body: "Your Item " + after.name + " has been booked. Click here to see"
            },
            data:{
               itemId:context.params.PostedItemId
            }
        });
        console.log('Message Sent');
    }
});
