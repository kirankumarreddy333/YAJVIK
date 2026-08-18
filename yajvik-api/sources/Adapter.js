class Adapter {
  constructor(name, baseUrl) {
    this.name = name;
    this.baseUrl = baseUrl;
  }

  async fetchJobs() {
    throw new Error('fetchJobs() must be implemented by subclass');
  }

  async fetchNews() {
    throw new Error('fetchNews() must be implemented by subclass');
  }

  async fetchResults() {
    throw new Error('fetchResults() must be implemented by subclass');
  }

  async fetchAdmitCards() {
    throw new Error('fetchAdmitCards() must be implemented by subclass');
  }
}

module.exports = Adapter;
