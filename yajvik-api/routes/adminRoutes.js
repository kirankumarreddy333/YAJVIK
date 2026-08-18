const express = require('express');
const router = express.Router();
const Job = require('../models/Job');
const News = require('../models/News');
// Add admin controllers/middleware in the future (e.g. JWT check)

// Dummy admin verification middleware
const verifyAdmin = (req, res, next) => {
  // In a real scenario, verify JWT token and role='admin'
  next();
};

// Verify a job manually
router.put('/jobs/:id/verify', verifyAdmin, async (req, res) => {
  try {
    const job = await Job.findByIdAndUpdate(req.params.id, {
      verificationStatus: 'verified',
      lastVerifiedAt: new Date()
    }, { new: true });
    
    if (!job) return res.status(404).json({ message: 'Job not found' });
    res.json(job);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get source health
router.get('/sources/health', verifyAdmin, async (req, res) => {
  res.json([
    { sourceName: 'UPSC', status: 'Healthy', lastChecked: new Date() },
    { sourceName: 'SSC', status: 'Warning', lastChecked: new Date() }
  ]);
});

module.exports = router;
