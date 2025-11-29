const fs = require('fs');
const path = require('path');
const sharp = require('sharp');
const ffmpeg = require('fluent-ffmpeg');
const Tesseract = require('tesseract.js');
const PDFDocument = require('pdfkit');
const PptxGenJS = require('pptxgenjs');
const { Document, Packer, Paragraph, TextRun } = require('docx');

const uploadDir = process.env.UPLOAD_DIR || './uploads';

class FileService {
  // Image operations
  async resizeImage(inputPath, outputPath, width, height) {
    await sharp(inputPath)
      .resize(width, height, { fit: 'inside', withoutEnlargement: true })
      .toFile(outputPath);
    return outputPath;
  }

  async compressImage(inputPath, outputPath, quality = 80) {
    const ext = path.extname(inputPath).toLowerCase();
    const pipeline = sharp(inputPath);
    
    if (ext === '.jpg' || ext === '.jpeg') {
      await pipeline.jpeg({ quality }).toFile(outputPath);
    } else if (ext === '.png') {
      await pipeline.png({ compressionLevel: 9 }).toFile(outputPath);
    } else if (ext === '.webp') {
      await pipeline.webp({ quality }).toFile(outputPath);
    } else {
      await pipeline.toFile(outputPath);
    }
    return outputPath;
  }

  async rotateImage(inputPath, outputPath, degrees) {
    await sharp(inputPath).rotate(degrees).toFile(outputPath);
    return outputPath;
  }

  async cropImage(inputPath, outputPath, left, top, width, height) {
    await sharp(inputPath).extract({ left, top, width, height }).toFile(outputPath);
    return outputPath;
  }

  async grayscaleImage(inputPath, outputPath) {
    await sharp(inputPath).grayscale().toFile(outputPath);
    return outputPath;
  }

  async convertImageFormat(inputPath, outputPath, format) {
    const pipeline = sharp(inputPath);
    
    switch(format.toLowerCase()) {
      case 'jpeg':
      case 'jpg':
        await pipeline.jpeg({ quality: 90 }).toFile(outputPath);
        break;
      case 'png':
        await pipeline.png().toFile(outputPath);
        break;
      case 'webp':
        await pipeline.webp().toFile(outputPath);
        break;
      case 'gif':
        await pipeline.gif().toFile(outputPath);
        break;
      default:
        throw new Error(`Unsupported format: ${format}`);
    }
    return outputPath;
  }

  // Image to document conversions
  async imageToPDF(inputPath, outputPath) {
    const doc = new PDFDocument();
    const stream = fs.createWriteStream(outputPath);
    doc.pipe(stream);
    
    const image = doc.openImage(inputPath);
    doc.image(image, 50, 50, { width: 500 });
    doc.end();
    
    return new Promise((resolve, reject) => {
      stream.on('finish', () => resolve(outputPath));
      stream.on('error', reject);
    });
  }

  async imageToPPTX(inputPath, outputPath) {
    const prs = new PptxGenJS();
    const slide = prs.addSlide();
    
    const imageData = fs.readFileSync(inputPath);
    const base64 = imageData.toString('base64');
    const ext = path.extname(inputPath).toLowerCase().substr(1);
    
    slide.addImage({
      data: `data:image/${ext};base64,${base64}`,
      x: 0.5,
      y: 0.5,
      w: 9,
      h: 5.5
    });
    
    await prs.writeFile(outputPath);
    return outputPath;
  }

  async imageToDOCX(inputPath, outputPath) {
    const imageData = fs.readFileSync(inputPath);
    const base64 = imageData.toString('base64');
    const ext = path.extname(inputPath).toLowerCase().substr(1);
    
    const doc = new Document({
      sections: [{
        children: [
          new Paragraph({
            children: [
              new TextRun({
                text: 'Converted Image',
                bold: true
              })
            ]
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: '',
                break: 1
              })
            ]
          })
        ]
      }]
    });
    
    const buffer = await Packer.toBuffer(doc);
    fs.writeFileSync(outputPath, buffer);
    return outputPath;
  }

  async imageToTXT(inputPath, outputPath, useOCR = false) {
    if (useOCR) {
      try {
        const result = await Tesseract.recognize(inputPath, 'eng');
        fs.writeFileSync(outputPath, result.data.text);
      } catch (err) {
        fs.writeFileSync(outputPath, '[OCR failed - image placeholder]');
      }
    } else {
      fs.writeFileSync(outputPath, '[Image converted to text - OCR disabled]');
    }
    return outputPath;
  }

  // Video compression
  async compressVideo(inputPath, outputPath, preset = '720p') {
    const presets = {
      '480p': { resolution: '854x480', bitrate: '1000k' },
      '720p': { resolution: '1280x720', bitrate: '2500k' },
      'low': { resolution: '640x360', bitrate: '500k' },
      'high': { resolution: '1920x1080', bitrate: '5000k' }
    };
    
    const config = presets[preset] || presets['720p'];
    
    return new Promise((resolve, reject) => {
      ffmpeg(inputPath)
        .output(outputPath)
        .videoCodec('libx264')
        .size(config.resolution)
        .videoBitrate(config.bitrate)
        .audioCodec('aac')
        .audioBitrate('128k')
        .on('end', () => resolve(outputPath))
        .on('error', reject)
        .run();
    });
  }

  // PDF utilities
  async mergePDFs(inputPaths, outputPath) {
    // Stub: requires pdf-lib or similar
    console.log('PDF merge stub - requires advanced PDF library');
    return outputPath;
  }

  async splitPDF(inputPath, outputPath, pageRanges) {
    // Stub: requires pdf-lib or similar
    console.log('PDF split stub - requires advanced PDF library');
    return outputPath;
  }

  async extractPDFText(inputPath) {
    // Stub: requires pdf-parse
    return 'Extracted text placeholder';
  }

  async extractPDFImages(inputPath, outputDir) {
    // Stub: requires pdf-lib
    return [];
  }

  // Document conversions
  async pdfToPPTX(inputPath, outputPath) {
    // Stub: complex conversion
    const prs = new PptxGenJS();
    const slide = prs.addSlide();
    slide.addText('PDF to PPTX conversion stub', { x: 1, y: 1, w: 8, h: 5 });
    await prs.writeFile(outputPath);
    return outputPath;
  }

  async pptxToPDF(inputPath, outputPath) {
    // Stub: complex conversion
    const doc = new PDFDocument();
    const stream = fs.createWriteStream(outputPath);
    doc.pipe(stream);
    doc.text('PPTX to PDF conversion stub');
    doc.end();
    return new Promise((resolve, reject) => {
      stream.on('finish', () => resolve(outputPath));
      stream.on('error', reject);
    });
  }

  async docxToPDF(inputPath, outputPath) {
    // Stub: complex conversion
    const doc = new PDFDocument();
    const stream = fs.createWriteStream(outputPath);
    doc.pipe(stream);
    doc.text('DOCX to PDF conversion stub');
    doc.end();
    return new Promise((resolve, reject) => {
      stream.on('finish', () => resolve(outputPath));
      stream.on('error', reject);
    });
  }

  async pdfToDOCX(inputPath, outputPath) {
    // Stub: complex conversion
    const doc = new Document({
      sections: [{
        children: [
          new Paragraph({
            children: [new TextRun('PDF to DOCX conversion stub')]
          })
        ]
      }]
    });
    const buffer = await Packer.toBuffer(doc);
    fs.writeFileSync(outputPath, buffer);
    return outputPath;
  }

  // PDF compression
  async compressPDF(inputPath, outputPath) {
    // Stub: requires pdf-lib
    fs.copyFileSync(inputPath, outputPath);
    return outputPath;
  }

  getFileSize(filePath) {
    return fs.statSync(filePath).size;
  }

  deleteFile(filePath) {
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }
  }
}

module.exports = new FileService();
