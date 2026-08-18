const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  phone: { type: String },
  state: { type: String },
  highestQualification: { type: String },
  targetJobs: [{ type: String }],
  bookmarkedJobIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Job' }],
  appliedJobIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Job' }],
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
