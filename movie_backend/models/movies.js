const mongoose = require('mongoose');

const castSchema = new mongoose.Schema({
  name: { type: String, required: true },
  role: { type: String, required: true },
  image: { type: String, required: true },
}, { _id: false }); // Avoids auto _id creation for each cast member

const movieSchema = new mongoose.Schema({
  _id: { type: String }, // If you're manually assigning IDs like "m2"
  title: { type: String, required: true },
  imageUrl: { type: String, required: true },
  genre: { type: String, required: true },
  description: { type: String, required: true },
  videoUrl: { type: String, required: true },
  movieUrl: { type: String }, // Optional field
  director: { type: String },
  rating: { type: Number },
  cast: [castSchema]
}, { collection: 'movies' });

module.exports = mongoose.model('Movie', movieSchema);
