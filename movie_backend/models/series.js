const mongoose = require('mongoose');

const seriesSchema = new mongoose.Schema({
  title: { type: String, required: true },
  imageUrl: { type: String, required: true },
  genre: { type: String, required: true },
  description: { type: String, required: true },
  videoUrl: { type: String, required: true },
  seasons: { type: Number, required: true },
  episodes: { type: Number, required: true }
}, { collection: 'series' });  // collection name

module.exports = mongoose.model('Series', seriesSchema);
