require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

// Import schema objects from models
const submissionSchema = require('./models/submission').schema;
const movieSchema = require('./models/movies').schema;
const seriesSchema = require('./models/series').schema;

const app = express();
app.use(cors());
app.use(express.json());

// Connect to movieDB for form submissions
const movieDB = mongoose.createConnection(process.env.MONGO_URI_MOVIEDB, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Connect to mediadb for movies and series
const mediaDB = mongoose.createConnection(process.env.MONGO_URI_MEDIADB, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Create models on the respective connections
const Submission = movieDB.model('Submission', submissionSchema);
const Movie = mediaDB.model('Movie', movieSchema);
const Series = mediaDB.model('Series', seriesSchema);

// POST API for submission form
app.post('/api/submit', async (req, res) => {
  try {
    const {
      companyName, contactPerson, email, phone, website,
      title, genre, duration, synopsis, trailer
    } = req.body;

    const sampleVideoUrl = 'https://www.w3schools.com/html/mov_bbb.mp4';

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
      videoUrl: sampleVideoUrl
    });

    await submission.save();
    res.status(200).json({ message: 'Submission successful!' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET API to fetch all movies from mediadb
app.get('/api/movies', async (req, res) => {
  try {
    const movies = await Movie.find({});
    res.json(movies);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET API to fetch all series from mediadb
app.get('/api/series', async (req, res) => {
  try {
    const series = await Series.find({});
    res.json(series);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Root route
app.get('/', (req, res) => {
  res.send('Backend is running!');
});

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
