const Job = require('../../models/Job');

async function validateAndSaveJob(parsedJobData) {
  try {
    // 1. Validator: Check required fields
    if (!parsedJobData.title || !parsedJobData.organization) {
      throw new Error('Invalid job data: Missing title or organization');
    }

    // 2. Duplicate Detection: Check if job with same title and org already exists
    const existingJob = await Job.findOne({
      title: parsedJobData.title,
      organization: parsedJobData.organization
    });

    if (existingJob) {
      // Update existing
      existingJob.lastVerified = new Date();
      existingJob.officialNotificationUrl = parsedJobData.officialNotificationUrl || existingJob.officialNotificationUrl;
      await existingJob.save();
      console.log(`[Validator] Updated existing job: ${existingJob.title}`);
      return existingJob;
    } else {
      // 3. Database Save
      const newJob = new Job(parsedJobData);
      await newJob.save();
      console.log(`[Validator] Inserted new job: ${newJob.title}`);
      return newJob;
    }
  } catch (error) {
    console.error('[Validator] Error:', error.message);
  }
}

module.exports = { validateAndSaveJob };
