const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
// Note: You need to place firebase-service-account.json in the backend folder
let serviceAccount;

try {
  // Try to load service account from file (for local development)
  serviceAccount = require('../firebase-service-account.json');
} catch (error) {
  // For production deployment, use environment variables
  serviceAccount = {
    type: "service_account",
    project_id: process.env.FIREBASE_PROJECT_ID || "ambabai-jewellers",
    private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
    private_key: process.env.FIREBASE_PRIVATE_KEY ? process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n') : undefined,
    client_email: process.env.FIREBASE_CLIENT_EMAIL,
    client_id: process.env.FIREBASE_CLIENT_ID,
    auth_uri: "https://accounts.google.com/o/oauth2/auth",
    token_uri: "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url: process.env.FIREBASE_CLIENT_CERT_URL
  };
}

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: 'ambabai-jewellers'
  });
}

const db = admin.firestore();

// Helper functions for Firestore operations
const FirebaseService = {
  // Collections
  users: () => db.collection('users'),
  jewelryItems: () => db.collection('jewelry_items'),
  orders: () => db.collection('orders'),

  // Utility functions
  serverTimestamp: () => admin.firestore.FieldValue.serverTimestamp(),
  
  // Convert Firestore document to plain object
  docToObject: (doc) => {
    if (!doc.exists) return null;
    return { id: doc.id, ...doc.data() };
  },

  // Convert Firestore query snapshot to array of objects
  queryToArray: (querySnapshot) => {
    return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  },

  // Generate unique SKU
  generateSKU: async (category, material) => {
    const prefix = `${category.substring(0,2).toUpperCase()}${material.substring(0,1).toUpperCase()}`;
    const timestamp = Date.now().toString().slice(-6);
    return `${prefix}-${timestamp}`;
  }
};

module.exports = { admin, db, FirebaseService };