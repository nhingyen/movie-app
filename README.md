# Movie Finder App

A movie streaming application built with Flutter, with data stored in Firebase Firestore.
The app displays detailed movie information including title, description, genre, poster, duration, release year, and video trailer.
It also comes with a set of basic and user-friendly features for easy interaction.

## Features

- Watch recommended movies
- Watch series
- Browse movies by category
- View movie details
- Save favorite movies
- View favorite movies list
- Search movies
- Watch video trailers

## Api Documentation

https://www.themoviedb.org/

## Tech Stack

**Client:** Dart, Flutter

**Server:** Node, Firestore

## Installation

Install my-project with github

```bash
  git clone https://github.com/nhingyen/movie-app.git
```

```bash
  # Go into the repository
  $ cd movie-app
```

```bash
  # Install dependencies
  $ flutter pub get
```

## Running Tests

```bash
  flutter run
```

run script to push .json to Firestore

```bash
  #run script
  npm install
  node push_movies.js
```

📸 Screenshots

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/screenshot_home1.jpg" width="32%" alt="Screen 1" />
<img src="assets/screenshots/screenshot_.jpg" width="32%" alt="Screen 2" />
<img src="assets/screenshots/screenshot_popular_movies.jpg" width="32%" alt="Screen 3" />
</div>

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/screenshot_series.jpg" width="32%" alt="Screen 1" />
<img src="assets/screenshots/screenshot_toprated.jpg" width="32%" alt="Screen 2" />
<img src="assets/screenshots/screenshot_search.jpg" width="32%" alt="Screen 3" />
</div>

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/screenshot_detail.jpg" width="32%" alt="Screen 1" />
<img src="assets/screenshots/screenshot_detail2.jpg" width="32%" alt="Screen 2" />
<img src="assets/screenshots/screenshot_favorite.jpg" width="32%" alt="Screen 3" />
</div>
