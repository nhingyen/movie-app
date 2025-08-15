const axios = require("axios");
const fs = require("fs");
const path = require("path");
const FILES = ["now_playing", "top_rated", "popular", "upcoming"];

async function getTrailerKey(movieId) {
  const url = `https://api.themoviedb.org/3/movie/${movieId}/videos?api_key=d595cdbd770bb65807690dc099be347a`;

  try {
    const response = await axios.get(url);
    const videos = response.data.results;

    const trailer = videos.find(
      (v) =>
        v.site === "YouTube" &&
        v.type === "Trailer" &&
        (v.official === true || v.official === undefined)
    );

    return trailer ? trailer.key : null;
  } catch (err) {
    console.error(
      `❌ Lỗi khi lấy trailer của phim ID ${movieId}:`,
      err.message
    );
    return null;
  }
}

async function processFile(fileName) {
  const filePath = path.join(__dirname, `${fileName}.json`);
  const raw = fs.readFileSync(filePath, "utf-8");
  const movies = JSON.parse(raw);

  for (let i = 0; i < movies.length; i++) {
    const movie = movies[i];
    if (!movie.trailerYoutubeKey) {
      console.log(`🔍 Đang lấy trailer cho: ${movie.title} (${movie.id})`);
      const key = await getTrailerKey(movie.id);
      movie.trailerYoutubeKey = key;
      await wait(300); // Delay để tránh quá tải API
    }
  }

  // ✅ Ghi ra file mới, không ghi đè
  const outputPath = path.join(__dirname, `${fileName}_with_trailer.json`);
  fs.writeFileSync(outputPath, JSON.stringify(movies, null, 2), "utf-8");
  console.log(`✅ Đã tạo file mới: ${fileName}_with_trailer.json`);
}

function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function run() {
  for (const file of FILES) {
    console.log(`🚀 Bắt đầu xử lý file ${file}.json...`);
    await processFile(file);
  }

  console.log("🎉 Hoàn tất thêm trailer cho tất cả file!");
}

run();
