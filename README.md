# EV Charging App

A full-stack Flutter application to help users locate and explore electric vehicle charging stations. This project integrates Firebase Phone Authentication, uses Flutter Riverpod for state management, and implements Clean Architecture with an MVVM pattern. The app also features interactive maps powered by OpenStreetMap via the `flutter_map` package.



## Features

- **User Authentication:**  
  Implements Firebase Phone Authentication with OTP verification. A "Skip Authentication" option is provided in case of errors.

- **Charger Discovery:**  
  Displays a full-screen interactive map (using OpenStreetMap) as the background, along with a horizontally scrolling list of station cards and a search bar for filtering.

- **Charger Details:**  
  Shows comprehensive details about a selected charging station, including images, address, facility information, and a "Get directions" button. Real-time polling is implemented to keep the station details updated.

- **Clean Architecture with MVVM:**  
  The app is structured with a Domain, Data, and Presentation layer. Riverpod is used for state management and ViewModels.

---

## Folder Structure

```plaintext
ev_charging_app/
├── android/                   
├── ios/                       
├── lib/
│   ├── data/
│   │   ├── models/
│   │   │   └── charging_station_model.dart
│   │   ├── repositories/
│   │   │   └── charging_station_repository_impl.dart
│   │   └── services/
│   │       └── api_service.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   └── charging_station.dart
│   │   ├── repositories/
│   │   │   └── charging_station_repository.dart
│   │   └── usecases/
│   │       ├── get_charging_stations.dart
│   │       └── get_charger_details.dart
│   ├── presentation/
│   │   ├── viewmodels/
│   │   │   ├── auth_viewmodel.dart
│   │   │   └── charging_station_viewmodel.dart
│   │   ├── views/
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── charger_discovery_screen.dart
│   │   │   └── charger_details_screen.dart
│   │   └── widgets/
│   │       └── map_widget.dart
│   ├── utils/
│   │   └── constants.dart
│   └── main.dart
├── pubspec.yaml
└── README.md


## Installation

** Clone the repository **
 ```bash
git clone https://github.com/nikhar-tale/Plug-Point-Flutter-app-.git
cd ev_charging_app




** Running the App**
 ```bash
flutter run

