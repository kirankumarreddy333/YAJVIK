const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
  subject: { type: String, required: true },
  topic: { type: String, required: true },
  questionText: { type: String, required: true },
  options: [{ type: String, required: true }],
  correctOptionIndex: { type: Number, required: true },
  explanation: { type: String, required: true },
  difficulty: { type: String, enum: ['easy', 'medium', 'hard'], required: true },
  isPremium: { type: Boolean, default: false },
  source: { type: String },
  verificationStatus: { 
    type: String, 
    enum: ['verified', 'unverified'],
    default: 'verified'
  }
}, { timestamps: true });

module.exports = mongoose.model('Question', questionSchema);
