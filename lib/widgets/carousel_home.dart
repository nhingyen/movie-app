import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';

class HomeCarousel extends StatefulWidget {
  final List<MovieModel> movies;

  const HomeCarousel({super.key, required this.movies});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  late PageController _pageController;
  int currentIndex = 0;
  late final Timer _timer;
  int _currentPage = 0;
  late List<MovieModel> loopedMovies;

  @override
  void initState() {
    super.initState();

    // Nhân 3 lần để tạo hiệu ứng lặp vô hạn
    loopedMovies = List.generate(
      3,
      (_) => widget.movies,
    ).expand((e) => e).toList();

    _currentPage = widget.movies.length; // Bắt đầu ở giữa
    _pageController = PageController(
      // initialPage: _currentPage,
      viewportFraction: 0.5,
    );

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        itemCount: loopedMovies.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
            _currentPage = index;
          });

          // Khi người dùng cuộn gần đầu/cuối thì reset về giữa
          if (index <= widget.movies.length ~/ 2 ||
              index >= loopedMovies.length - widget.movies.length ~/ 2) {
            final middlePage = widget.movies.length;
            _pageController.jumpToPage(middlePage);
            _currentPage = middlePage;
          }
        },
        itemBuilder: (context, index) {
          final movie = loopedMovies[index];

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0;

              if (_pageController.hasClients &&
                  _pageController.position.haveDimensions) {
                value = _pageController.page! - index;
              } else {
                value = currentIndex - index.toDouble();
              }

              value = value.clamp(-1, 1);
              final double rotationY = value * 0.9;
              final double scale = 1 - (value.abs() * 0.2);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotationY),
                child: Transform.scale(
                  scale: scale,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500${movie.backdropPath ?? ''}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      'Lỗi tải ảnh',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title ?? 'Không có tiêu đề',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
