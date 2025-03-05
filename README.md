# Lifelog - Mood and Wellness Tracker

## Description

Lifelog is a mobile application designed to help users track their mood and overall day to day activities. The app provides various features that allow users to monitor their well-being through daily logs, interactive calendars, and graph summaries.

## Features

### 1. Authentication

- Users can register and log in to their accounts.
- Users can update their profile information.

### 2. Daily Mood and Wellness Tracking

- Users can record their mood by selecting from a set of emojis.
- Users can write daily notes or highlight important events.
- Users can log what they are grateful for each day.
- Users can track their sleep hours (start and end times).
- Users can upload a current photo using camera services.
- Users can add their current location for each day.

### 3. Interactive Calendar

- The home screen displays a calendar for the current month.
- Users can view past recorded days.
- A randomly selected inspirational quote from an external API is displayed on the home screen.

### 4. Graph Summary of Records

- Users can view weekly and monthly charts summarizing trends in their mood and sleep patterns.

## Technologies and Services Used

- **Flutter** for building the mobile application
- **Firebase Authentication** for user login and registration.
- **Firestore** for storing user records & **Firebase Storage** for storing images.
- **External API** for fetching inspirational quotes.
- **OpenStreetMap** for displaying the user's location.

## Installation
Before doing anything, make sure you have flutter installed, and have an emulator set up on your machine.

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/lifelog.git
   ```
2. Navigate to the project folder:
   ```sh
   cd lifelog
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

