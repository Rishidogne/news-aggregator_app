# 📰 News Aggregator App

A Flutter-based News Aggregator App that displays top headlines and allows users to mark articles as favorites. Built with Flutter, Node.js, and MongoDB.

---

## 🚀 Features

- Fetch latest news articles using a backend API
- Categorize news (e.g., business, sports, tech)
- Mark/unmark articles as favorites
- Save favorites in MongoDB via Node.js backend
- View full articles in browser
- Responsive UI and smooth UX

---


## 🛠️ Tech Stack

### Flutter (Frontend)
- `http` – to fetch news data
- `GetX` – for state management (if used)
- `url_launcher` – to open articles
- `shared_preferences` (optional)

### Node.js (Backend)
- Express.js – API server
- MongoDB – database for storing favorite articles

---

## 🧑‍💻 How to Run

### Flutter App
```bash
git clone https://github.com/Rishidogne/news-aggregator_app.git
cd news-aggregator_app
flutter pub get
flutter run

---

###  APP backend
cd backend  # if backend is in a separate folder
npm install
node server.js
