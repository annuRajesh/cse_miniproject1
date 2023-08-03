const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifySellerOrderReceived = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snapshot, context) => {
    const orderData = snapshot.data();
    const sellerId = orderData.sellerId;

    // Fetch the seller document from Firestore
    const sellerSnapshot = await admin.firestore().collection('sellers').doc(sellerId).get();
    const sellerData = sellerSnapshot.data();

    if (!sellerData || !sellerData.fcmToken) {
      console.error('Error: Seller document not found or FCM token missing for seller:', sellerId);
      return null;
    }

    const sellerFCMToken = sellerData.fcmToken;

    const payload = {
      notification: {
        title: 'New Order Received',
        body: 'You have received a new order!',
      },
    };

    try {
      await admin.messaging().sendToDevice(sellerFCMToken, payload);
      console.log('Notification sent successfully to seller:', sellerId);
    } catch (error) {
      console.error('Error sending notification to seller:', sellerId, error);
    }

    return null;
  });
