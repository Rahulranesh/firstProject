const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, required: true }, // 'image-convert', 'image-compress', 'doc-convert', 'video-compress', etc.
  status: { type: String, enum: ['Pending', 'Running', 'Completed', 'Failed'], default: 'Pending' },
  inputFile: { type: String, required: true },
  outputFile: { type: String },
  parameters: { type: mongoose.Schema.Types.Mixed },
  error: { type: String },
  createdAt: { type: Date, default: Date.now },
  completedAt: { type: Date },
  fileSize: { type: Number },
  outputFileSize: { type: Number }
});

module.exports = mongoose.model('Job', jobSchema);
