const mongoose = require('mongoose');

const submissionSchema = new mongoose.Schema({
  companyName: String,
  contactPerson: String,
  email: String,
  phone: String,
  website: String,
  title: String,
  genre: String,
  duration: String,
  synopsis: String,
  trailer: String,
  videoUrl: String, // Store a URL (real or placeholder)
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Submission', submissionSchema);
