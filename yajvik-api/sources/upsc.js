const Adapter = require('./Adapter');

class UPSCAdapter extends Adapter {
  constructor() {
    super('UPSC', 'https://upsc.gov.in');
  }

  async fetchJobs() {
    // In a real scenario, this would use axios and cheerio to fetch and parse
    // Since we must NOT fake successful integrations when not legally/technically retrieving:
    // We will return an empty array or connect to a real RSS/API feed if available.
    console.log(`[${this.name}] Fetching jobs from ${this.baseUrl}...`);
    
    // For now, return an empty array until real HTML parsing/RSS is implemented
    return [];
  }
}

module.exports = new UPSCAdapter();
