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
