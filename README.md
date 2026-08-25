<div align="center">

# 🚀 YAJVIK

**«Build. Automate. Analyze. Ship.»**

*A modern, unified platform for discovering, tracking, and managing Government Jobs and Competitive Exams in India.*

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Frontend](https://img.shields.io/badge/Frontend-React%20%7C%20Vite-61DAFB?logo=react&logoColor=black)](#)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%7C%20Express-339933?logo=node.js&logoColor=white)](#)
[![Mobile](https://img.shields.io/badge/Mobile-Flutter-02569B?logo=flutter&logoColor=white)](#)

</div>

---

## ✨ Overview

YAJVIK is a comprehensive ecosystem designed to simplify the process of discovering and applying for Indian government jobs. It bridges the gap between scattered recruitment notifications and applicants by offering a unified dashboard, personalized tracking, and timely updates. 

This repository contains the complete source code for the platform, which includes:
- **Web Frontend**: A fast, modern React SPA powered by Vite.
- **API Backend**: A robust Node.js/Express server handling data synchronization, user accounts, and notifications.
- **Mobile App**: A cross-platform Flutter application for iOS and Android, allowing users to track their progress on the go.

---

## 🎯 Problem Statement

Finding authentic government job notifications (UPSC, SSC, Banking, Railways) is tedious and often confusing. Candidates have to navigate through multiple clunky official websites, and tracking the application lifecycle (Exam -> Admit Card -> Result -> Interview) across different platforms is a massive headache.

## 💡 Solution

YAJVIK solves this by aggregating recruitment data into a single, intuitive platform. It provides smart filtering, bookmarks, and a dedicated **Application Tracker** that walks candidates through every stage of the hiring process, ensuring they never miss a deadline.

---

## 🚀 Key Features

- ⚡ **Centralized Job Board**: Browse jobs across Central, State, UPSC, SSC, Banking, Defence, and more.
- 🔎 **Advanced Search & Filters**: Find opportunities by department, qualification, location, and deadline.
- 📱 **Cross-Platform**: Accessible via web browsers and a dedicated mobile application.
- 🔐 **Application Tracker**: Manage your journey from Application to Selection.
- 📊 **Smart Bookmarks**: Save important jobs and get alerts for approaching deadlines.
- 🤖 **Automated Sync**: Background cron jobs automatically fetch the latest notifications from high-priority sources.

---

## 🧠 How It Works

```mermaid
flowchart LR
    A[User] -->|Web Browser| B[yajvik-web (React)]
    A -->|Mobile App| C[YAJVIK App (Flutter)]
    B --> D[yajvik-api (Node.js/Express)]
    C --> D
    D --> E[(MongoDB)]
    D -->|Cron Jobs| F[External Govt Sources]
```

---

## 🛠️ Tech Stack

| Category | Technology |
| :--- | :--- |
| **Frontend** | React, TypeScript, Vite |
| **Backend** | Node.js, Express.js |
| **Mobile** | Flutter, Dart |
| **Database** | MongoDB |
| **Styling** | Vanilla CSS / Material UI |
| **Deployment** | Firebase (Web) |

---

## 📂 Project Structure

```text
YAJVIK/
├── yajvik-api/         # Node.js backend API
│   ├── cron.js         # Automated job scraping schedules
│   ├── routes/         # API endpoints
│   ├── sources/        # Adapters for various recruitment sites
│   └── server.js       # Entry point
├── yajvik-web/         # React web frontend
│   ├── src/            # UI components and pages
│   └── vite.config.ts  # Build configuration
└── YAJVIK/             # Flutter mobile application
    ├── lib/            # Dart source code
    │   ├── screens/    # Mobile views
    │   └── models/     # Data schemas
    └── pubspec.yaml    # Flutter dependencies
```

---

## ⚙️ Installation

To set up the project locally, clone the repository:

```bash
git clone https://github.com/kirankumarreddy333/YAJVIK.git
cd YAJVIK
```

### Backend (yajvik-api)

```bash
cd yajvik-api
npm install
npm start
```

### Frontend (yajvik-web)

```bash
cd ../yajvik-web
npm install
npm run dev
```

### Mobile App (YAJVIK)

Make sure Flutter is installed on your system.

```bash
cd ../YAJVIK
flutter pub get
flutter run
```

---

## 🔑 Environment Variables

Configuration requires environment variables for security. Create a `.env` file in the respective directories based on the `.env.example` templates provided.

**Backend (`yajvik-api/.env`)**:
```env
PORT=5000
MONGODB_URI=your_mongodb_uri_here
```

**Frontend (`yajvik-web/.env`)**:
```env
VITE_FIREBASE_API_KEY=your_firebase_api_key_here
VITE_FIREBASE_PROJECT_ID=your_firebase_project_id_here
```

> **IMPORTANT**: Never commit `.env` files or real credentials to GitHub.

---

## 🔒 Security

Security is a priority for YAJVIK:
- 🛡️ Secrets and API keys are strictly managed via environment variables.
- 🚫 `.env` files are ignored by Git to prevent accidental exposure.
- 🔑 Users must configure their own credentials for deployment and database connections.
- 🔐 Real credentials should never be committed to the repository.

---

## 🔮 Future Improvements

- *Job Deadline Notifications*
- *AI Government Job Assistant*
- *Personalized job recommendations*
- *Syllabus and previous papers integration*

---

## 🤝 Contributing

Contributions are welcome! If you'd like to improve the platform, please fork the repository, create a feature branch, and submit a pull request.

---

## 👨‍💻 Author

**Kiran Velicharla**
- GitHub: [@kirankumarreddy333](https://github.com/kirankumarreddy333)

---

## 📜 License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for details.
