# DocXpress Flutter Frontend Setup

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point with routing
│   ├── models/
│   │   ├── user_model.dart      # User and AuthResponse models
│   │   ├── note_model.dart      # Note model
│   │   └── file_model.dart      # UploadedFile model
│   ├── services/
│   │   └── dio_client.dart      # HTTP client with JWT interceptor
│   ├── repositories/
│   │   ├── auth_repository.dart # Auth API calls
│   │   ├── note_repository.dart # Note API calls
│   │   └── file_repository.dart # File upload & picker
│   ├── providers/
│   │   ├── auth_provider.dart   # Auth state management
│   │   ├── note_provider.dart   # Note state management
│   │   └── file_provider.dart   # File upload state
│   └── screens/
│       ├── splash_screen.dart
│       ├── main_screen.dart     # Bottom navigation
│       ├── home_screen.dart
│       ├── notes_screen.dart
│       ├── note_detail_screen.dart
│       ├── upload_screen.dart
│       ├── convert_screen.dart  # Placeholder
│       ├── profile_screen.dart
│       └── auth/
│           ├── login_screen.dart
│           └── register_screen.dart
├── pubspec.yaml
└── README.md
```

## Installation & Running

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- Android Studio or Xcode (for emulator)

### Steps

1. **Navigate to flutter_app**:
```bash
cd flutter_app
```

2. **Get dependencies**:
```bash
flutter pub get
```

3. **Update backend URL** (if not localhost):
   - Edit `lib/services/dio_client.dart`
   - Change `baseUrl` to your backend URL

4. **Run the app**:
```bash
flutter run
```

Or on specific device:
```bash
flutter run -d <device_id>
```

## Key Features

### Authentication
- Register with name, email, password
- Login with email and password
- JWT token stored securely using `flutter_secure_storage`
- Auto-attach JWT to all requests via Dio interceptor
- Logout clears token and navigates to login

### Notes
- Create new notes
- View all notes in list
- Edit existing notes
- Delete notes
- Real-time sync with backend

### File Upload
- **Camera**: Take photos directly
- **Gallery**: Pick images from device
- **File Picker**: Select any file type
- **Multiple Upload**: Upload multiple files at once
- **File Display**: Shows uploaded files with icons and sizes

### Navigation
- Splash screen checks authentication
- Bottom navigation with 5 tabs
- Automatic routing based on auth state

### UI/UX
- Material 3 design
- Error handling with snackbars
- Loading indicators
- Empty states
- Responsive layout

## API Integration

All API calls go through `DioClient` singleton which:
1. Maintains base URL and timeout settings
2. Automatically attaches JWT token to requests
3. Handles 401 errors by clearing token
4. Provides secure token storage

## State Management

Uses `Provider` package:
- `AuthProvider`: Manages login, register, logout, user profile
- `NoteProvider`: Manages note CRUD operations
- `FileProvider`: Manages file uploads and selections

## Error Handling

- Network errors show snackbar messages
- Invalid credentials display error messages
- Failed operations show user-friendly messages
- Loading states prevent duplicate submissions

## Next Steps

For next phase, implement:
1. Conversion endpoints (image-to-PDF, etc.)
2. Compression features
3. Job history viewing
4. Download functionality
5. Advanced file preview
