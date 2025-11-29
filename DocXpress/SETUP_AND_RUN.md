# DocXpress - Complete Setup & Running Guide

## Prerequisites
- Node.js and npm installed
- Flutter SDK installed (version 3.0.0+)
- MongoDB running locally or a remote MongoDB connection
- A code editor like VS Code

## Step 1: Setup & Install Dependencies

### Backend Setup (Node.js/Express)
```bash
# Navigate to the root directory (where package.json is)
cd /home/ranesh/MY_APPS/DocXpress

# Install backend dependencies
npm install
```

### Frontend Setup (Flutter)
```bash
# Navigate to Flutter app directory
cd /home/ranesh/MY_APPS/DocXpress/flutter_app

# Install Flutter dependencies
flutter pub get

# (Optional) Clean previous builds
flutter clean
```

## Step 2: Environment Configuration

The `.env` file has been created with default values. Update it if needed:
- `MONGODB_URI`: MongoDB connection string (default: mongodb://localhost:27017/docxpress)
- `JWT_SECRET`: Secret key for JWT tokens
- `PORT`: Backend server port (default: 5000)

## Step 3: Running the Application

### Option A: Using VS Code Tasks (Recommended)

1. **Install Backend Dependencies**
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type: `Tasks: Run Task`
   - Select: `Backend: Install Dependencies`

2. **Start Backend Server** (Terminal 1)
   - Press `Ctrl+Shift+P`
   - Type: `Tasks: Run Task`
   - Select: `Backend: Run Server` or `Backend: Run Server (Dev Mode)` for development
   - Backend will run on `http://localhost:5000`

3. **Install Flutter Dependencies** (Terminal 2)
   - Press `Ctrl+Shift+P`
   - Type: `Tasks: Run Task`
   - Select: `Flutter: Install Dependencies`

4. **Run Flutter App** (Terminal 2)
   - Press `Ctrl+Shift+P`
   - Type: `Tasks: Run Task`
   - Select: `Flutter: Run App`
   - Choose your device/emulator when prompted

### Option B: Using Terminal Commands

**Terminal 1 - Backend:**
```bash
cd /home/ranesh/MY_APPS/DocXpress
npm install      # First time only
npm start        # For production
# OR
npm run dev      # For development (with nodemon)
```

**Terminal 2 - Frontend:**
```bash
cd /home/ranesh/MY_APPS/DocXpress/flutter_app
flutter pub get  # First time only
flutter run
```

## API Endpoints

- Health Check: `GET http://localhost:5000/health`
- Auth: `POST http://localhost:5000/api/auth/register`, `POST http://localhost:5000/api/auth/login`
- Notes: `GET/POST/PUT/DELETE http://localhost:5000/api/notes`
- Files: `GET/POST http://localhost:5000/api/files`
- Jobs: `GET/POST http://localhost:5000/api/jobs`

## Troubleshooting

### Flutter errors after pub get
- Run: `flutter clean` and `flutter pub get` again
- Ensure Flutter SDK path is correct in VS Code settings

### Backend not starting
- Check if port 5000 is already in use
- Ensure MongoDB is running
- Check `.env` file configuration
- Review error logs in terminal

### VS Code Terminal not working
- Settings have been configured in `.vscode/settings.json`
- Try restarting VS Code
- Use external terminal as alternative

## Project Structure

```
DocXpress/
├── backend (Node.js/Express)
│   ├── routes/          # API route handlers
│   ├── models/          # MongoDB models
│   ├── middleware/      # Auth and upload middleware
│   ├── services/        # Business logic
│   ├── server.js        # Main server file
│   └── package.json     # Dependencies
│
└── flutter_app/         # Flutter mobile app
    ├── lib/
    │   ├── screens/     # UI screens
    │   ├── providers/   # State management
    │   ├── repositories/# Data layer
    │   ├── models/      # Data models
    │   └── main.dart    # App entry point
    └── pubspec.yaml     # Dependencies
```

## Development Notes

- Backend runs on PORT 5000 by default
- Flutter app connects to backend via HTTP at `localhost:5000`
- Use `npm run dev` for development with auto-reload
- Use `flutter run -d chrome` to test on web during development
