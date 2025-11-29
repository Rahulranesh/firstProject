# DocXpress Backend

All-in-one scanning, document conversion, compression, and note-taking utility backend.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables:
```bash
cp .env.example .env
# Edit .env with your MongoDB URI and JWT secret
```

3. Start the server:
```bash
npm start
# or for development with auto-reload:
npm run dev
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get user profile (requires auth)

### Notes
- `POST /api/notes` - Create note
- `GET /api/notes` - List user's notes
- `GET /api/notes/:id` - Get note details
- `PUT /api/notes/:id` - Update note
- `DELETE /api/notes/:id` - Delete note

### File Operations
- `POST /api/files/upload` - Upload files
- `POST /api/files/image/resize` - Resize image
- `POST /api/files/image/compress` - Compress image
- `POST /api/files/image/rotate` - Rotate image
- `POST /api/files/image/crop` - Crop image
- `POST /api/files/image/grayscale` - Convert to grayscale
- `POST /api/files/image/convert-format` - Convert image format
- `POST /api/files/convert/image-to-pdf` - Convert image to PDF
- `POST /api/files/convert/image-to-pptx` - Convert image to PPTX
- `POST /api/files/convert/image-to-docx` - Convert image to DOCX
- `POST /api/files/convert/image-to-txt` - Convert image to TXT (with OCR)
- `POST /api/files/video/compress` - Compress video
- `POST /api/files/pdf/compress` - Compress PDF
- `POST /api/files/convert/pdf-to-pptx` - Convert PDF to PPTX
- `POST /api/files/convert/pptx-to-pdf` - Convert PPTX to PDF
- `POST /api/files/convert/docx-to-pdf` - Convert DOCX to PDF
- `POST /api/files/convert/pdf-to-docx` - Convert PDF to DOCX
- `GET /api/files/download/:filename` - Download file

### Jobs
- `GET /api/jobs` - List user's jobs
- `GET /api/jobs/:id` - Get job details
- `DELETE /api/jobs/:id` - Delete job

### Admin (requires admin role)
- `GET /api/admin/users` - List all users
- `GET /api/admin/jobs` - List all jobs
- `GET /api/admin/stats` - Get system statistics

## Response Format

All endpoints return JSON with the following structure:
```json
{
  "success": true/false,
  "data": {},
  "message": "optional message",
  "error": "error message if success is false"
}
```

## Architecture

- **Models**: User, Note, Job
- **Services**: FileService (handles all file operations)
- **Middleware**: Authentication, file upload handling
- **Routes**: Auth, Notes, Files, Jobs, Admin

## File Storage

Currently uses local filesystem storage. Can be extended to support S3 or other cloud storage by modifying the upload middleware and file service.
