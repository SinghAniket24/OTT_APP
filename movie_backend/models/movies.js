const mongoose = require('mongoose');

const movieSchema = new mongoose.Schema({
  title: { type: String, required: true },
  imageUrl: { type: String, required: true },
  genre: { type: String, required: true },
  description: { type: String, required: true },
  videoUrl: { type: String, required: true }
}, { collection: 'movies' });  //Collection name from mongodb

module.exports = mongoose.model('Movie', movieSchema);
