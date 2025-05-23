require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Submission = require('./models/submission');

const app = express();
app.use(cors());
app.use(express.json());

// Connect to MongoDB
const mongoURI = process.env.MONGO_URI;
mongoose.connect(mongoURI);

// API endpoint for form submission (video upload logic commented out)
app.post('/api/submit', /* upload.single('video'), */ async (req, res) => {
  try {
    const {
      companyName, contactPerson, email, phone, website,
      title, genre, duration, synopsis, trailer
    } = req.body;

    // Placeholder/sample video URL for now
    const sampleVideoUrl = 'https://www.w3schools.com/html/mov_bbb.mp4';

    // If you want to handle video upload in the future, uncomment and use:
    // const videoUrl = req.file ? 'URL_OR_PATH_TO_UPLOADED_VIDEO' : sampleVideoUrl;

    const submission = new Submission({
      companyName,
      contactPerson,
      email,
      phone,
      website,
      title,
      genre,
      duration,
      synopsis,
      trailer,
      videoUrl: sampleVideoUrl // Use sample for now
    });

    await submission.save();
    res.status(200).json({ message: 'Submission successful!' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// (Optional) Test route
app.get('/', (req, res) => {
  res.send('Backend is running!');
});

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));
