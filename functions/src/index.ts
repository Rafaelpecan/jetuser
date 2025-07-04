import {onCall, CallableRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK (Server-side)
admin.initializeApp();

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onCall((data, context) => {
  logger.info("Hello logs!", {structuredData: true});
  return {data: "heloooooooooo porrraaa"};
});

export const getUserData = onCall(async (request: CallableRequest, context) => {
  if (!request.auth) { // ✅ Correct way to check authentication
    return {data: "nenhum usuário autenticado"};
  }

  try {
    const snapshot = await admin.firestore()
      .collection("users")
      .doc(request.auth.uid) // ✅ Correct way to access UID
      .get();

    if (!snapshot.exists) {
      return {data: "usuário não encontrado"};
    }

    return {data: snapshot.data()};
  } catch (error) {
    return {error: "Erro ao buscar usuário"};
  }
});
