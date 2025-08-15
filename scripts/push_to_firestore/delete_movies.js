// delete_movie.js
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json"); // Đảm bảo đúng đường dẫn

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function deleteAllDocumentsInCollection(collectionName) {
  const collectionRef = db.collection(collectionName);
  const snapshot = await collectionRef.get();

  if (snapshot.empty) {
    console.log("No documents found in the collection.");
    return;
  }

  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();
  console.log(
    `Deleted ${snapshot.size} documents from '${collectionName}' collection.`
  );
}

deleteAllDocumentsInCollection("movies") // 🔁 Đổi tên collection nếu cần
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deleting documents:", error);
    process.exit(1);
  });
