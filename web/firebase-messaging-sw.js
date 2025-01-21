// Import Firebase scripts
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js");

// Initialize Firebase app with your Firebase config
firebase.initializeApp({
    apiKey: "AIzaSyBPb_QWi9jUetE87ZPPmw3JYfFHRi2ZkEs",
    authDomain: "village-f1c7a.firebaseapp.com",
    projectId: "village-f1c7a",
    storageBucket: "village-f1c7a.firebasestorage.app",
    messagingSenderId: "983843065218",
    appId: "1:983843065218:web:7b850803e9ee813c8fd39b",
    measurementId: "G-ZXKT17FGX9"
});
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
  
  console.log('[firebase-messaging-sw.js] Received background message', payload);

  const notificationTitle = payload.notification?.title || 'No Title';
  const notificationOptions = {
    body: payload.notification?.body || 'No Body',
    icon: payload.notification?.icon || '/icon.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
