const {onCall} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendPushNotification = onCall(async (request) => {
  const {token, title, body, extraData} = request.data;

  if (!token || !title || !body) {
    throw new Error("Missing required fields: token, title, or body.");
  }

  const message = {
    token,
    notification: {
      title,
      body,
    },
    data: extraData || {},
  };

  try {
    const response = await admin.messaging().send(message);
    logger.info("Notification sent:", response);
    return {success: true};
  } catch (error) {
    logger.error("Notification failed:", error);
    throw new Error("Notification failed to send.");
  }
});
