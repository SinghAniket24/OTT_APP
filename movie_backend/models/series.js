// const mongoose = require('mongoose');

// const seriesSchema = new mongoose.Schema({
//   title: { type: String, required: true },
//   imageUrl: { type: String, required: true },
//   genre: { type: String, required: true },
//   description: { type: String, required: true },
//   videoUrl: { type: String, required: true },
//   seasons: { type: Number, required: true },
//   episodes: { type: Number, required: true }
// }, { collection: 'series' });  // collection name

// module.exports = mongoose.model('Series', seriesSchema);
const mongoose = require('mongoose');

const episodeSchema = new mongoose.Schema({
  episodeNumber: { type: Number, required: true },
  title: { type: String, required: true },
  thumbnail: { type: String, required: true },
  description: { type: String, required: true },
  videoUrl: { type: String, required: true },
}, { _id: false });

const seasonSchema = new mongoose.Schema({
  seasonNumber: { type: Number, required: true },
  title: { type: String, required: true },
  thumbnail: { type: String, required: true },
  description: { type: String, required: true },
  videoUrl: { type: String, required: true },
  episodes: { type: [episodeSchema], required: true }
}, { _id: false });

const castSchema = new mongoose.Schema({
  name: { type: String, required: true },
  role: { type: String, required: true },
  image: { type: String, required: true }
}, { _id: false });

const seriesSchema = new mongoose.Schema({
  title: { type: String, required: true },
  imageUrl: { type: String, required: true },
  genre: { type: String, required: true },
  description: { type: String, required: true },
  videoUrl: { type: String, required: true },
  seasons: { type: Number, required: true },
  episodes: { type: Number, required: true },
  director: { type: String, required: true },
  cast: { type: [castSchema], required: true },
  rating: { type: Number, required: true },
  seasonDetails: { type: [seasonSchema], required: false }
}, { collection: 'series' });

module.exports = mongoose.model('Series', seriesSchema);
