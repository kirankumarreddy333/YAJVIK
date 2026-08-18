const cron = require('node-cron');
const upscAdapter = require('./sources/upsc');
// const Job = require('./models/Job');

function startCronJobs() {
  console.log('Starting scheduled cron jobs...');

  // High-priority recruitment sources: Every 60 minutes
  cron.schedule('0 * * * *', async () => {
    console.log('Running high-priority source sync...');
    try {
      const upscJobs = await upscAdapter.fetchJobs();
      // Logic to normalize, validate, duplicate detection, and save to DB
      console.log(`Fetched ${upscJobs.length} jobs from UPSC.`);
    } catch (error) {
      console.error('Error syncing UPSC:', error);
    }
  });

  // News and Current affairs: Every 4 hours
  cron.schedule('0 */4 * * *', async () => {
    console.log('Running news sync...');
    // Sync news here
  });
}

module.exports = { startCronJobs };
