// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:offering_collection_app/main.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

// class FirebaseApi {
//   // create an instance of Firebase Messaging
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   // function to initialize notifications
//   Future<void> initNotifications() async {
//     // request permission from user (will prompt user)
//     await _firebaseMessaging.requestPermission();

//     // fetch the FCM token for this device
//     final fcmToken = await _firebaseMessaging.getToken();

//     // print the token (normally you would send this to your server)
//     print('Token' + ' ' + fcmToken.toString());

//     // initialize further settings for push notification
//     initPushNotification();
//   }

//   // function to handle received messages
//   void handleMessage(RemoteMessage? message) {
//     // if the message is null, do nothing
//     if (message == null) return;

//     // navigate to new screen when message is received and user taps notification
//     navigatorKey.currentState?.pushNamed(
//       '/notification_page',
//       arguments: message,
//     );
//   }

//   // function to initialize background settings
//   Future initPushNotification() async {
//     // handle notification if the app was terminated and now opened
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     // attach event listeners for when a notification opens the app
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   }
// }