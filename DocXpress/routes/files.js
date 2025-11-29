const express = require('express');
const path = require('path');
const fs = require('fs');
const { authenticate } = require('../middleware/auth');
const upload = require('../middleware/upload');
const fileService = require('../services/fileService');
const Job = require('../models/Job');

const router = express.Router();
const uploadDir = process.env.UPLOAD_DIR || './uploads';

router.use(authenticate);

// Upload single or multiple files
router.post('/upload', upload.array('files', 10), async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({ success: false, error: 'No files uploaded' });
    }

    const uploadedFiles = req.files.map(file => ({
      filename: file.filename,
      originalName: file.originalname,
      size: file.size,
      path: `/uploads/${req.userId}/${file.filename}`,
      mimetype: file.mimetype
    }));

    res.json({ success: true, data: uploadedFiles });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image resize
router.post('/image/resize', async (req, res) => {
  try {
    const { filename, width, height } = req.body;
    if (!filename || !width || !height) {
      return res.status(400).json({ success: false, error: 'Missing parameters' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `resized-${Date.now()}.png`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    await fileService.resizeImage(inputPath, outputPath, width, height);

    res.json({
      success: true,
      data: {
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        size: fileService.getFileSize(outputPath)
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image compress
router.post('/image/compress', async (req, res) => {
  try {
    const { filename, quality = 80 } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `compressed-${Date.now()}${path.extname(filename)}`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    await fileService.compressImage(inputPath, outputPath, quality);

    res.json({
      success: true,
      data: {
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        size: fileService.getFileSize(outputPath)
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image rotate
router.post('/image/rotate', async (req, res) => {
  try {
    const { filename, degrees } = req.body;
    if (!filename || degrees === undefined) {
      return res.status(400).json({ success: false, error: 'Missing parameters' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `rotated-${Date.now()}${path.extname(filename)}`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    await fileService.rotateImage(inputPath, outputPath, degrees);

    res.json({
      success: true,
      data: {
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image crop
router.post('/image/crop', async (req, res) => {
  try {
    const { filename, left, top, width, height } = req.body;
    if (!filename || left === undefined || top === undefined || !width || !height) {
      return res.status(400).json({ success: false, error: 'Missing parameters' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `cropped-${Date.now()}${path.extname(filename)}`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    await fileService.cropImage(inputPath, outputPath, left, top, width, height);

    res.json({
      success: true,
      data: {
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image grayscale
router.post('/image/grayscale', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `grayscale-${Date.now()}${path.extname(filename)}`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    await fileService.grayscaleImage(inputPath, outputPath);

    res.json({
      success: true,
      data: {
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image format conversion
router.post('/image/convert-format', async (req, res) => {
  try {
    const { filename, format } = req.body;
    if (!filename || !format) {
      return res.status(400).json({ success: false, error: 'Missing parameters' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.${format}`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    await fileService.convertImageFormat(inputPath, outputPath, format);

    res.json({
      success: true,
      data: {
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image to PDF
router.post('/convert/image-to-pdf', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.pdf`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'image-to-pdf',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.imageToPDF(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image to PPTX
router.post('/convert/image-to-pptx', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.pptx`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'image-to-pptx',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.imageToPPTX(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image to DOCX
router.post('/convert/image-to-docx', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.docx`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'image-to-docx',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.imageToDOCX(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Image to TXT (with optional OCR)
router.post('/convert/image-to-txt', async (req, res) => {
  try {
    const { filename, useOCR = false } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.txt`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'image-to-txt',
      status: 'Running',
      inputFile: filename,
      parameters: { useOCR }
    });
    await job.save();

    try {
      await fileService.imageToTXT(inputPath, outputPath, useOCR);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Video compress
router.post('/video/compress', async (req, res) => {
  try {
    const { filename, preset = '720p' } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `compressed-${Date.now()}.mp4`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'video-compress',
      status: 'Running',
      inputFile: filename,
      parameters: { preset }
    });
    await job.save();

    try {
      await fileService.compressVideo(inputPath, outputPath, preset);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// PDF compress
router.post('/pdf/compress', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `compressed-${Date.now()}.pdf`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'pdf-compress',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.compressPDF(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Document conversions
router.post('/convert/pdf-to-pptx', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.pptx`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'pdf-to-pptx',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.pdfToPPTX(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.post('/convert/pptx-to-pdf', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.pdf`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'pptx-to-pdf',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.pptxToPDF(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.post('/convert/docx-to-pdf', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.pdf`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'docx-to-pdf',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.docxToPDF(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.post('/convert/pdf-to-docx', async (req, res) => {
  try {
    const { filename } = req.body;
    if (!filename) {
      return res.status(400).json({ success: false, error: 'Filename required' });
    }

    const inputPath = path.join(uploadDir, req.userId, filename);
    const outputFilename = `converted-${Date.now()}.docx`;
    const outputPath = path.join(uploadDir, req.userId, outputFilename);

    const job = new Job({
      userId: req.userId,
      type: 'pdf-to-docx',
      status: 'Running',
      inputFile: filename,
      parameters: {}
    });
    await job.save();

    try {
      await fileService.pdfToDOCX(inputPath, outputPath);
      job.status = 'Completed';
      job.outputFile = outputFilename;
      job.outputFileSize = fileService.getFileSize(outputPath);
      job.completedAt = new Date();
    } catch (err) {
      job.status = 'Failed';
      job.error = err.message;
    }
    await job.save();

    res.json({
      success: true,
      data: {
        jobId: job._id,
        filename: outputFilename,
        path: `/uploads/${req.userId}/${outputFilename}`,
        status: job.status
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Download file
router.get('/download/:filename', (req, res) => {
  try {
    const filePath = path.join(uploadDir, req.userId, req.params.filename);
    
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ success: false, error: 'File not found' });
    }

    res.download(filePath);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = router;
