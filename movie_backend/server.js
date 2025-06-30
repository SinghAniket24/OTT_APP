require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require('http');
const { Server } = require('socket.io');
const { v4: uuidv4 } = require('uuid');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

// Middleware
app.use(cors());
app.use(express.json());

// DB Connections
const movieDB = mongoose.createConnection(process.env.MONGO_URI_MOVIEDB, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const mediaDB = mongoose.createConnection(process.env.MONGO_URI_MEDIADB, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const userDB = mongoose.createConnection(process.env.MONGO_URI_USERDB, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Schemas and Models
const submissionSchema = require('./models/submission').schema;
const movieSchema = require('./models/movies').schema;
const seriesSchema = require('./models/series').schema;

const Submission = movieDB.model('Submission', submissionSchema);
const Movie = mediaDB.model('Movie', movieSchema);
const Series = mediaDB.model('Series', seriesSchema);

const userSchema = new mongoose.Schema({
  uid: { type: String, required: true, unique: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  aadhar: { type: String, required: true },
  phone: { type: String, required: true },
});
const User = userDB.model('User', userSchema);

// Chat and Stream Schemas
const messageSchema = new mongoose.Schema({
  roomId: { type: String, required: true },
  from: { type: String, required: true },
  text: { type: String, required: true },
  timestamp: { type: Date, default: Date.now },
}, { versionKey: false });

const liveStreamSchema = new mongoose.Schema({
  roomId: String,
  email: String,
  title: String,
  startedAt: Date,
  hostSocketId: String,
  thumbnail: String,
  endedAt: Date,
  viewers: Number,
}, { timestamps: true });

const Message = userDB.model('Message', messageSchema);
const LiveStream = userDB.model('LiveStream', liveStreamSchema);

// In-memory viewer tracking
const streamViewers = new Map();

// Socket.IO logic
io.on("connection", (socket) => {
  console.log("🔌 Socket connected:", socket.id);

  // --- Chat ---
  socket.on("joinRoom", async ({ roomId, email }, callback) => {
    try {
      socket.join(roomId);
      const history = await Message.find({ roomId }).sort({ timestamp: 1 }).limit(100);
      socket.emit("chatHistory", history);
      socket.to(roomId).emit("userJoined", { email });
      callback?.({ status: "success" });
    } catch (err) {
      callback?.({ status: "error", error: err.message });
    }
  });

  socket.on("sendMessage", async (data, callback) => {
    const { roomId, from, text } = data;
    if (!roomId || !from || !text?.trim()) {
      callback?.({ status: "error", error: "Missing fields" });
      return;
    }

    try {
      const msg = new Message({ roomId, from, text });
      const saved = await msg.save();
      io.to(roomId).emit("receiveMessage", saved);
      callback?.({ status: "success", message: saved });
    } catch (err) {
      callback?.({ status: "error", error: err.message });
    }
  });

  // --- Live Stream ---
  socket.on("startStream", async ({ email, title }, callback) => {
    try {
      const roomId = uuidv4();
      const newStream = new LiveStream({
        roomId,
        email,
        title,
        startedAt: new Date(),
        hostSocketId: socket.id,
        thumbnail: `https://ui-avatars.com/api/?name=${encodeURIComponent(email)}&background=random`,
        viewers: 0
      });

      await newStream.save();
      streamViewers.set(roomId, new Set());

      io.emit("newLiveStarted", newStream);
      callback?.({ status: "success", stream: newStream });
    } catch (err) {
      callback?.({ status: "error", error: err.message });
    }
  });

  socket.on("endStream", async ({ roomId }, callback) => {
    try {
      await LiveStream.findOneAndUpdate(
        { roomId },
        { $set: { endedAt: new Date() } }
      );

      streamViewers.delete(roomId);
      io.emit("liveEnded", { roomId });
      callback?.({ status: "success" });
    } catch (err) {
      callback?.({ status: "error", error: err.message });
    }
  });

  socket.on("joinStream", ({ roomId, email }, callback) => {
    try {
      socket.join(roomId);

      if (!streamViewers.has(roomId)) {
        streamViewers.set(roomId, new Set());
      }
      streamViewers.get(roomId).add(socket.id);

      const viewers = streamViewers.get(roomId).size;
      io.emit("viewerUpdate", { roomId, viewers });

      callback?.({ status: "success", viewers });
    } catch (err) {
      callback?.({ status: "error", error: err.message });
    }
  });

  socket.on("leaveStream", ({ roomId }) => {
    if (streamViewers.has(roomId)) {
      streamViewers.get(roomId).delete(socket.id);
      const viewers = streamViewers.get(roomId).size;
      io.emit("viewerUpdate", { roomId, viewers });
    }
    socket.leave(roomId);
  });

  socket.on("disconnect", () => {
    console.log("❌ Socket disconnected:", socket.id);
    streamViewers.forEach((viewers, roomId) => {
      if (viewers.has(socket.id)) {
        viewers.delete(socket.id);
        io.emit("viewerUpdate", { roomId, viewers: viewers.size });
      }
    });
  });
});

// --- API Routes ---
// Movies, series, users, submissions (your original routes remain untouched)

app.post('/api/submit', async (req, res) => {
  try {
    const {
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
      videoUrl: sampleVideoUrl,
    });

    await submission.save();
    res.status(200).json({ message: 'Submission successful!' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/movies', async (req, res) => {
  try {
    const movies = await Movie.find({});
    res.json(movies);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/series', async (req, res) => {
  try {
    const series = await Series.find({});
    res.json(series);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

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

app.get('/api/user', async (req, res) => {
  try {
    const users = await User.find({});
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Live stream list APIs
app.get("/live-streams", async (req, res) => {
  try {
    const streams = await LiveStream.find({ endedAt: { $exists: false } });
    const data = streams.map((s) => ({
      ...s.toObject(),
      viewers: streamViewers.get(s.roomId)?.size || 0
    }));
    res.json({ status: "success", data });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get("/past-streams", async (req, res) => {
  try {
    const streams = await LiveStream.find({ endedAt: { $exists: true } }).sort({ startedAt: -1 }).limit(50);
    res.json({ status: "success", data: streams });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Root test
app.get('/', (req, res) => {
  res.send('Backend is running!');
});

// Start server
const port = process.env.PORT || 5000;
server.listen(port, () => {
  console.log(`🚀 Server with Socket.IO running at http://localhost:${port}`);
});
