# DocXpress API Endpoints

## Authentication
- **POST** `/api/auth/register` - Register new user
- **POST** `/api/auth/login` - Login user
- **GET** `/api/auth/profile` - Get user profile (auth required)

## Notes Management
- **POST** `/api/notes` - Create note (auth required)
- **GET** `/api/notes` - List user's notes (auth required)
- **GET** `/api/notes/:id` - Get note details (auth required)
- **PUT** `/api/notes/:id` - Update note (auth required)
- **DELETE** `/api/notes/:id` - Delete note (auth required)

## File Upload
- **POST** `/api/files/upload` - Upload single/multiple files (auth required)

## Image Operations
- **POST** `/api/files/image/resize` - Resize image (auth required)
- **POST** `/api/files/image/compress` - Compress image (auth required)
- **POST** `/api/files/image/rotate` - Rotate image (auth required)
- **POST** `/api/files/image/crop` - Crop image (auth required)
- **POST** `/api/files/image/grayscale` - Convert to grayscale (auth required)
- **POST** `/api/files/image/convert-format` - Convert image format (auth required)

## Image to Document Conversion
- **POST** `/api/files/convert/image-to-pdf` - Convert image to PDF (auth required)
- **POST** `/api/files/convert/image-to-pptx` - Convert image to PPTX (auth required)
- **POST** `/api/files/convert/image-to-docx` - Convert image to DOCX (auth required)
- **POST** `/api/files/convert/image-to-txt` - Convert image to TXT with OCR (auth required)

## Document Conversions
- **POST** `/api/files/convert/pdf-to-pptx` - Convert PDF to PPTX (auth required)
- **POST** `/api/files/convert/pptx-to-pdf` - Convert PPTX to PDF (auth required)
- **POST** `/api/files/convert/docx-to-pdf` - Convert DOCX to PDF (auth required)
- **POST** `/api/files/convert/pdf-to-docx` - Convert PDF to DOCX (auth required)

## Compression
- **POST** `/api/files/video/compress` - Compress video (auth required)
- **POST** `/api/files/pdf/compress` - Compress PDF (auth required)

## Download
- **GET** `/api/files/download/:filename` - Download file (auth required)

## Job Management
- **GET** `/api/jobs` - List user's jobs (auth required)
- **GET** `/api/jobs/:id` - Get job details (auth required)
- **DELETE** `/api/jobs/:id` - Delete job (auth required)

## Admin Endpoints (admin role required)
- **GET** `/api/admin/users` - List all users
- **GET** `/api/admin/jobs` - List all jobs
- **GET** `/api/admin/stats` - Get system statistics

## Health Check
- **GET** `/health` - Server health check
