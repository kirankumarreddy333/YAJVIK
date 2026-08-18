const axios = require('axios');
const cheerio = require('cheerio');
const { validateAndSaveJob } = require('./validator');

// SSC Fetcher Example
async function fetchSSCJobs() {
  try {
    console.log('[Scraper] Fetching SSC Jobs...');
    // Real implementation would scrape ssc.nic.in
    const mockHtml = `
      <div class="notice">
        <h3>SSC CGL 2026 Notification</h3>
        <a href="/pdf/cgl2026.pdf">Download</a>
      </div>
    `;
    const $ = cheerio.load(mockHtml);
    
    // Parse
    const jobs = [];
    $('.notice').each((i, el) => {
      jobs.push({
        title: $(el).find('h3').text(),
        organization: 'Staff Selection Commission (SSC)',
        category: 'SSC',
        sourceUrl: 'https://ssc.nic.in',
        officialNotificationUrl: 'https://ssc.nic.in' + $(el).find('a').attr('href'),
        lastVerified: new Date(),
        state: 'Central'
      });
    });

    // Validate and Save
    for (const job of jobs) {
      await validateAndSaveJob(job);
    }
    
    return jobs.length;
  } catch (error) {
    console.error('[Scraper] SSC Fetch Error:', error);
  }
}

module.exports = { fetchSSCJobs };
