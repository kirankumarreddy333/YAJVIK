const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
  title: { type: String, required: true },
  organization: { type: String, required: true },
  department: { type: String },
  category: { type: String, required: true },
  description: { type: String },
  qualification: { type: String },
  ageLimit: { type: String },
  ageRelaxation: { type: String },
  vacancies: { type: Number, default: 0 },
  salary: { type: String },
  location: { type: String },
  applicationStartDate: { type: Date },
  applicationEndDate: { type: Date },
  examDate: { type: Date },
  selectionProcess: { type: String },
  applicationFee: { type: String },
  notificationUrl: { type: String },
  officialApplyUrl: { type: String },
  officialWebsiteUrl: { type: String },
  sourceName: { type: String },
  sourceUrl: { type: String },
  verificationStatus: { 
    type: String, 
    enum: ['verified', 'unverified', 'expired', 'cancelled', 'draft'],
    default: 'unverified'
  },
  lastVerifiedAt: { type: Date }
}, { timestamps: true });

module.exports = mongoose.model('Job', jobSchema);
