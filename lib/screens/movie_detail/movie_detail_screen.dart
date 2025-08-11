import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_event.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_state.dart';
import 'package:movie_app/services/firestore_service.dart';
import 'package:movie_app/services/hive_setup.dart';
import 'package:movie_app/screens/list_movie/movie_list_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;
  final MovieModel?
  initialMovie; // Thêm tham số để nhận MovieModel từ FavoriteScreen

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.initialMovie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Box<MovieModel> favoriteBox = HiveSetup.getFavoritesBox();
  bool _isFavorite = false;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    setState(() {
      _isFavorite = favoriteBox.containsKey(widget.movieId);
    });
  }

  void toggleFavorite(MovieModel item) {
    final alreadyFavorite = favoriteBox.containsKey(item.id);
    if (alreadyFavorite) {
      favoriteBox.delete(item.id);
      _checkFavoriteStatus();
      print('Removed $item from favorites');
    } else {
      final movieWithTimestamp = MovieModel.copyWithTimestamp(item);
      favoriteBox.put(item.id, movieWithTimestamp);
      setState(() {
        _isFavorite = true;
      });
      print(
        'Added $movieWithTimestamp with timestamp: ${movieWithTimestamp.timestamp}',
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.title} đã được ${_isFavorite ? '' : 'bỏ '}yêu thích',
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Không cần dispose WebViewController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MovieDetailBloc(firestoreService: FirestoreService())
                ..add(LoadMovieDetailEvent(widget.movieId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(31, 43, 42, 42),
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MovieDetailBloc>().add(
                          LoadMovieDetailEvent(widget.movieId),
                        );
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            } else if (state is MovieDetailLoaded) {
              return _buildMovieDetail(
                state.movie,
                state.trailerKey,
                state.relatedMovies,
              );
            }
            return const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetail(
    MovieModel movie,
    String? trailerKey,
    List<MovieModel> popularMovies,
  ) {
    // Khởi tạo WebViewController khi có trailerKey
    if (trailerKey != null && _webViewController == null) {
      try {
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..loadRequest(
            Uri.parse(
              'https://www.youtube.com/embed/$trailerKey?autoplay=0&mute=1',
            ),
          );
      } catch (e) {
        print('Error initializing WebViewController: $e');
        _webViewController = null; // Đặt null nếu lỗi để fallback về hình ảnh
      }
    }

    return SingleChildScrollView(
      key:
          UniqueKey(), // Đảm bảo mỗi lần render tạo mới widget, tránh lặp nội dung
      physics: const ClampingScrollPhysics(), // Kiểm soát cuộn mượt mà
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần header (hình ảnh hoặc trailer)
          SizedBox(
            height: 270, // Chiều cao cố định
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (trailerKey != null && _webViewController != null)
                  WebViewWidget(controller: _webViewController!)
                else
                  Image.network(
                    'https://image.tmdb.org/t/p/w500/${movie.posterPath ?? movie.backdropPath ?? ''}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text(
                        'Lỗi tải hình ảnh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Positioned(
                  top: 20,
                  left: 1,
                  right: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      // InkWell(
                      //   onTap: () => toggleFavorite(movie),
                      //   child: Icon(
                      //     _isFavorite
                      //         ? Icons.favorite
                      //         : Icons.favorite_border_outlined,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (movie.releaseDate != null)
                      Text(
                        '${movie.releaseDate!.split('-')[0]}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(width: 12),
                    if (movie.runtime != null)
                      Text(
                        '${movie.runtime} phút',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                if (movie.voteAverage != null)
                  Row(
                    children: [
                      Text(
                        'Lượt vote: ${movie.voteAverage}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(Icons.star, color: Colors.yellow, size: 15),
                    ],
                  ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292B37),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF292B37).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => toggleFavorite(movie),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292B37),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF292B37).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292B37),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF292B37).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tóm tắt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  movie.overview ?? 'Không có mô tả',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 5),
                // Phần Phim Thịnh Hành
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Phim Thịnh Hành',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieListScreen(
                                    title: 'Phim Thịnh Hành',
                                    endpoint: 'popular',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                              size: 30,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (popularMovies.isNotEmpty)
                        SizedBox(
                          height: 235, // Chiều cao cố định để tránh lỗi cuộn
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics:
                                const NeverScrollableScrollPhysics(), // Ngăn cuộn bên trong
                            itemCount: popularMovies.length > 7
                                ? 7
                                : popularMovies.length,
                            itemBuilder: (context, index) {
                              final movieItem = popularMovies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(
                                        movieId: movieItem.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 145,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF292B37),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Image.network(
                                          "https://image.tmdb.org/t/p/w500${movieItem.backdropPath ?? movieItem.posterPath ?? ''}",
                                          height: 180,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Center(
                                                  child: Text(
                                                    'Lỗi tải hình ảnh',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                movieItem.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'Rating: ${movieItem.voteAverage.toStringAsFixed(1)}',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        const Text(
                          'Không có phim thịnh hành',
                          style: TextStyle(color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
