# TechBarter - User Platform

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Web](https://img.shields.io/badge/Web-Portal-blue?style=for-the-badge)

A Flutter-based web application for Users to view and purchase various products. 

## 🛠 Built With
- Flutter (v3.27.3)
- Dart
- Firebase (Cloud storage for large files)
- Spring Boot (Backend API gateway)
- Render (for deployment)


## 🚀 Quick Start

### Option 1: Run Locally (Development)

### Prerequisites
- Flutter SDK (v3.27.3)
- Chrome browser (for web testing)
- Git

### Installation
1. Clone the repository
   ```sh
   git clone https://github.com/nishh1810/TechBarter.git
   cd tech_barter

2. Install dependencies
   ```sh
   flutter pub get

3. Remove CORS ERROR

   1- Go to flutter SDK: flutter\bin\cache and remove a file named: flutter_tools.stamp

   2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.

   3- Find '--disable-extensions'

   4- Add '--disable-web-security'

4. Run the app
   ```sh
   flutter run -d chrome --web-port=4002

### Option 2: Use the Live Demo

🔗 Deployed Link: https://tech-barter-app.onrender.com

🔑 Test Credentials

| Username | Password  |
|----------|-----------|
| nike3201 | 0000      |

### 📂 Project Structure

  ```sh
  tech_barter_seller/  
  ├── lib/  
  │   ├── screens/            # UI pages  
  │       ├── components/     # Reusable components  
  │   ├── models/             # Data classes  
  │   ├── services/           # API & business logic
  │   ├── utils/              # Helper functions
  │   ├── providers/          # State management
  │   └── main.dart           # App entry point  
  ├── pubspec.yaml            # Dependencies  
  └── README.md


