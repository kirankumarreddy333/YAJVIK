# jobupdtxk 🇮🇳

A Flutter **Government Jobs listing + application tracker app** focused on helping users discover, track, and manage government job opportunities in India.

This is the **core v1**: a government job board with search, filters, bookmarks, job details, and an application tracker — built with clean, swappable architecture so real government job data can be connected later without changing the UI.

## What's included

* **Government Job Board** — Browse government job opportunities across:

  * Central Government
  * State Government
  * UPSC
  * SSC
  * Banking
  * Railway
  * Defence
  * Police
  * Teaching
  * PSU
  * Courts
  * Healthcare
  * Engineering
  * Other Government Jobs

* **Search & Filters** — Quickly find jobs by:

  * Department
  * Job category
  * Qualification
  * Location
  * Salary
  * Application deadline

* **Job Details** — View complete information including:

  * Job title
  * Department
  * Eligibility
  * Educational qualification
  * Age limit
  * Salary
  * Application dates
  * Exam dates
  * Selection process
  * Application fee
  * Official notification link

* **Bookmarks** — Save important government jobs for later.

* **Closing Soon** — Highlight jobs with approaching application deadlines.

* **Application Tracker** — Track your application through:

  * Applied
  * Exam
  * Admit Card
  * Result
  * Interview
  * Selected
  * Rejected

* **Settings**

  * Basic profile
  * Dark mode
  * Light mode
  * Theme preference persistence

* **Material 3 UI** — Modern, clean Flutter interface with both light and dark themes.

## Project Structure

```text
lib/
  main.dart                    # App entry and provider wiring

  theme/
    app_theme.dart             # Light + dark ThemeData

  models/
    job.dart                   # Government Job model
    job_application.dart       # Application tracker model

  data/
    job_repository.dart        # Abstract job data interface
    mock_job_repository.dart   # Sample government job data

  providers/
    job_provider.dart          # Government job state
    tracker_provider.dart      # Application tracker state
    theme_provider.dart        # Theme management

  screens/
    home_screen.dart           # Government job dashboard
    job_detail_screen.dart     # Job details
    tracker_screen.dart        # Application tracker
    settings_screen.dart       # Settings
    main_shell.dart            # Main navigation

  widgets/
    job_card.dart              # Government job card
    category_chip.dart         # Job category filter
    status_chip.dart           # Application status
```

## Run the App

Make sure Flutter is installed on your system.

```bash
flutter pub get
flutter run
```

## Government Job Categories

The app is designed around major Indian government recruitment categories:

```text
Central Government
State Government
UPSC
SSC
Banking
Railway
Defence
Police
Teaching
PSU
Courts
Healthcare
Engineering
Other Government Jobs
```

## Connecting Real Government Job Data

The current version uses `MockJobRepository` for sample data.

To connect real government job data:

### 1. Create an API Repository

Create:

```text
lib/data/api_job_repository.dart
```

Implement the existing `JobRepository` interface and map the API response to `Job` objects.

### 2. Replace the Mock Repository

In `main.dart`, replace:

```dart
ChangeNotifierProvider(
  create: (_) => JobProvider(MockJobRepository()),
),
```

with:

```dart
ChangeNotifierProvider(
  create: (_) => JobProvider(ApiJobRepository()),
),
```

### 3. UI Remains Unchanged

All screens communicate through `JobProvider`, so the UI does not need to be rewritten when real government job data is connected.

## Future Roadmap — v2+

* 🔔 Government job deadline notifications
* 📢 New job alerts
* 📝 Exam date reminders
* 📄 Admit card notifications
* 📊 Government exam preparation section
* 📚 Syllabus and previous papers
* 🤖 AI Government Job Assistant
* 🎯 Eligibility checker
* 📅 Government exam calendar
* 📁 Resume & certificate document vault
* ⭐ Personalized job recommendations
* ☁️ Cloud sync
* 🔐 Google/GitHub login
* 📈 Application analytics

## Vision

**jobupdtxk** aims to become a simple platform for discovering and tracking **Indian Government Jobs and Competitive Exams** in one place.

From finding a suitable government job to tracking the application, exam, admit card, result, and final selection — everything can be managed from a single app.

## Disclaimer

jobupdtxk is an independent job-information platform. Users should always verify recruitment details, eligibility, dates, fees, and other information from the **official government recruitment notification or official website** before applying.

## License

This project is currently intended for educational and development purposes.
