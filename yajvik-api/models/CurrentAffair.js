const mongoose = require('mongoose');

const currentAffairSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String },
  category: { type: String, required: true },
  source: { type: String, required: true },
  publishedAt: { type: Date, required: true },
  sourceUrl: { type: String, unique: true },
}, { timestamps: true });

module.exports = mongoose.model('CurrentAffair', currentAffairSchema);
