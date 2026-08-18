const mongoose = require('mongoose');
const Job = require('./models/Job');
const Question = require('./models/Question');
require('dotenv').config();

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/yajvik';

const seedData = async () => {
  try {
    await mongoose.connect(MONGODB_URI);
    console.log('Connected to DB for seeding');

    await Job.deleteMany({});
    
    const now = new Date();
    const jobs = [
      {
        title: 'Scientist / Engineer - SC',
        organization: 'ISRO',
        department: 'Space Research',
        govtType: 'central',
        state: 'All India',
        category: 'Engineering',
        examName: 'ISRO ICRB 2026',
        postName: 'Scientist/Engineer',
        notificationNumber: 'ISRO:ICRB:01:2026',
        examYear: 2026,
        vacancies: 62,
        qualification: 'BE/B.Tech',
        ageLimit: '28 Years',
        salary: '₹56,100 - ₹1,77,500 (Level 10)',
        lastDate: new Date(now.getTime() + 4 * 24 * 60 * 60 * 1000),
        examDate: new Date(now.getTime() + 40 * 24 * 60 * 60 * 1000),
        selectionProcess: 'Written Test + Interview',
        eligibility: 'BE/BTech in ECE/CSE, min 65% or 6.84 CGPA',
        applyLink: 'https://www.isro.gov.in/Careers.html',
        officialWebsite: 'https://www.isro.gov.in'
      },
      {
        title: 'Junior Engineer (Electronics)',
        organization: 'RRB',
        department: 'Indian Railways',
        govtType: 'central',
        state: 'All India',
        category: 'Railway',
        examName: 'RRB JE 2026',
        postName: 'Junior Engineer',
        notificationNumber: 'CEN 03/2026',
        examYear: 2026,
        vacancies: 2148,
        qualification: 'Diploma / BE',
        ageLimit: '18-33 Years',
        salary: '₹35,400 (Level 6)',
        lastDate: new Date(now.getTime() + 12 * 24 * 60 * 60 * 1000),
        examDate: new Date(now.getTime() + 55 * 24 * 60 * 60 * 1000),
        selectionProcess: 'CBT 1 + CBT 2 + Document Verification',
        eligibility: 'Diploma/BE in Electronics/ECE, age 18-33',
        applyLink: 'https://www.rrbcdg.gov.in',
        officialWebsite: 'https://indianrailways.gov.in'
      },
      {
        title: 'Probationary Officer',
        organization: 'IBPS',
        department: 'Public Sector Banks',
        govtType: 'central',
        state: 'All India',
        category: 'Bank',
        examName: 'IBPS PO 2026',
        postName: 'Probationary Officer',
        notificationNumber: 'CRP PO/MT-XVI',
        examYear: 2026,
        vacancies: 3955,
        qualification: 'Graduation',
        ageLimit: '20-30 Years',
        salary: '₹48,480 - ₹85,920',
        lastDate: new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000),
        examDate: new Date(now.getTime() + 60 * 24 * 60 * 60 * 1000),
        selectionProcess: 'Prelims + Mains + Interview',
        eligibility: 'Any Graduate, age 20-30',
        applyLink: 'https://www.ibps.in',
        officialWebsite: 'https://www.ibps.in'
      }
    ];

    await Job.insertMany(jobs);
    console.log('Jobs seeded successfully!');
    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

seedData();
