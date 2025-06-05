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

// Connect to user_data for user signup info
const userDB = mongoose.createConnection(process.env.MONGO_URI_USERDB, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Create models on the respective connections
const Submission = movieDB.model('Submission', submissionSchema);
const Movie = mediaDB.model('Movie', movieSchema);
const Series = mediaDB.model('Series', seriesSchema);

// Define User schema and model for user_data
const userSchema = new mongoose.Schema({
  uid: { type: String, required: true, unique: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  aadhar: { type: String, required: true },
  phone: { type: String, required: true }
});
const User = userDB.model('User', userSchema);

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

//  POST API to add user
app.post('/api/user', async (req, res) => {
  try {
    const { uid, email, password, aadhar, phone } = req.body;

    if (!uid || !email || !password || !aadhar || !phone) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const existingUser = await User.findOne({ uid });
    if (existingUser) {
      return res.status(409).json({ error: 'User with this UID already exists' });
    }

    const newUser = new User({ uid, email, password, aadhar, phone });
    await newUser.save();

    res.status(201).json({ message: 'User added successfully', user: newUser });
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


//Get for user_data


app.get('/api/user', async (req, res) => {
  try {
    const users = await User.find({});
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
