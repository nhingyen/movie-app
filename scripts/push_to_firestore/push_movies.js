const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

// Hàm bỏ dấu tiếng Việt
function removeVietnameseTones(str) {
  return str
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D");
}

// Hàm tạo mảng từ khóa từ title
function generateSearchKeywords(title) {
  if (!title) return [];

  const lowerTitle = removeVietnameseTones(title.toLowerCase());
  const words = lowerTitle.split(/\s+/).filter(Boolean);

  const keywords = new Set();

  // Thêm từng từ riêng lẻ
  words.forEach((word) => keywords.add(word));

  // Thêm cụm từ liên tiếp
  for (let start = 0; start < words.length; start++) {
    let phrase = "";
    for (let end = start; end < words.length; end++) {
      phrase += (phrase ? " " : "") + words[end];
      keywords.add(phrase);
    }
  }

  return Array.from(keywords);
}

// Khởi tạo Firebase Admin SDK
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// 2. Hàm xóa toàn bộ documents trong collection
// async function deleteAllDocuments(collectionName) {
//   const snapshot = await db.collection(collectionName).get();
//   const batchSize = snapshot.size;
//   if (batchSize === 0) {
//     console.log(`✅ Collection "${collectionName}" trống.`);
//     return;
//   }

//   const batch = db.batch();
//   snapshot.docs.forEach((doc) => {
//     batch.delete(doc.ref);
//   });

//   await batch.commit();
//   console.log(
//     `🗑️ Đã xóa ${batchSize} documents khỏi collection "${collectionName}"`
//   );
// }

// Hàm đọc file JSON và push từng phim vào Firestore
async function uploadMoviesFromFile(category, filePath) {
  const uploadedMovieIds = new Set();
  const fileData = fs.readFileSync(filePath, "utf-8");
  const movies = JSON.parse(fileData); // mảng phim

  for (const movie of movies) {
    const movieId = movie.id?.toString();
    if (!movieId || uploadedMovieIds.has(movieId)) continue;

    uploadedMovieIds.add(movieId); // Đánh dấu là đã xử lý

    // console.log("Thêm phim:", {
    //   title: movie.title,
    //   posterPath: movie.posterPath,
    //   backdropPath: movie.backdropPath,
    // });
    const searchKeywords = generateSearchKeywords(movie.title ?? "");

    await db
      .collection("movies")
      .add({
        id: movie.id ?? null,
        title: movie.title ?? "No title",
        titleLower: (movie.title ?? "").toLowerCase(),
        searchKeywords: searchKeywords, // thêm mảng từ khóa
        posterPath: movie.posterPath ?? movie.poster_path ?? "",
        backdropPath: movie.backdropPath ?? movie.backdrop_path ?? "",
        voteAverage: movie.voteAverage ?? 0,
        releaseDate: movie.releaseDate ?? "",
        overview: movie.overview ?? "",
        genreIds: movie.genreIds ?? [],
        genres: movie.genres ?? [],
        runtime: movie.runtime ?? null,
        video: movie.video ?? false,
        trailerYoutubeKey: movie.trailerYoutubeKey ?? null,
        category: category, // now_playing, popular, v.v.
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      })
      .then(() => console.log(`Đã thêm phim: ${movie.title}`))
      .catch((err) => console.error("Lỗi khi thêm phim:", err));
  }
}

// Gọi hàm upload cho từng file
(async () => {
  await uploadMoviesFromFile("now_playing", "now_playing_with_trailer.json");
  await uploadMoviesFromFile("top_rated", "top_rated_with_trailer.json");
  await uploadMoviesFromFile("popular", "popular_with_trailer.json");
  await uploadMoviesFromFile("upcoming", "upcoming_with_trailer.json");

  console.log("Hoàn tất đẩy dữ liệu lên Firestore!");
})();
