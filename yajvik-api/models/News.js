const mongoose = require('mongoose');

const newsSchema = new mongoose.Schema({
  title: { type: String, required: true },
  summary: { type: String },
  category: { type: String, required: true },
  source: { type: String, required: true },
  publishedAt: { type: Date, required: true },
  imageUrl: { type: String },
  sourceUrl: { type: String, required: true, unique: true },
  verificationStatus: { 
    type: String, 
    enum: ['verified', 'unverified'],
    default: 'verified'
  }
}, { timestamps: true });

module.exports = mongoose.model('News', newsSchema);
