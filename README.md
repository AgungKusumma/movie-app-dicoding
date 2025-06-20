# 🎬 Ditonton – Flutter Movie App

[![Build status](https://api.codemagic.io/apps/6854d420493da21664fdeb7f/6854d420493da21664fdeb7e/status_badge.svg)](https://codemagic.io/app/6854d420493da21664fdeb7f/6854d420493da21664fdeb7e/latest_build)

A Flutter-based movie catalog app developed as part of the **Dicoding Android Expert Capstone Project**. The app displays a list of popular movies and TV shows using data from The Movie Database (TMDb) API.

---

## 1️⃣ Features

- View a list of **popular movies and TV shows**
- View detailed information for each item (overview, rating, genres, etc.)
- **Add or remove favorites**
- Built with **provider** for state management
- **Local data persistence** using `sqflite`

---

## 2️⃣ Tech Stack

| Tech               | Description                           |
|--------------------|---------------------------------------|
| Flutter            | UI toolkit                            |
| Dart               | Programming language                  |
| Provider           | State management                      |
| HTTP               | API requests                          |
| SQLite (`sqflite`) | Local storage for favorites           |
| CachedNetworkImage | Efficient image loading & caching     |
| GetIt              | Dependency injection                  |
| Dartz, Equatable   | Functional and comparison helpers     |

---

## 3️⃣ Getting Started
STG
### Step 1: Clone the Repository

```bash
git clone https://github.com/AgungKusumma/movie-app-dicoding.git
```

### Step 2: Navigate to the Project Directory

```bash
cd movie-app-dicoding
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

```bash
flutter run
```