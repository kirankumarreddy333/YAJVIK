const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

// Basic routes to test
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'YAJVIK API is running' });
});

app.use('/api/jobs', require('./routes/jobRoutes'));
app.use('/api/admin', require('./routes/adminRoutes'));

const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/yajvik';

const { startCronJobs } = require('./cron');

mongoose.connect(MONGODB_URI)
  .then(() => {
    console.log('Connected to MongoDB');
    startCronJobs();
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('MongoDB connection error:', err);
  });
