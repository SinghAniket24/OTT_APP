module.exports = (io) => {
  const chatRooms = {}; // In-memory room storage

  io.on("connection", (socket) => {
    console.log("🟢 New client connected:", socket.id);

    socket.on("joinRoom", ({ roomId, email }, callback) => {
      socket.join(roomId);
      if (!chatRooms[roomId]) chatRooms[roomId] = [];

      console.log(`${email} joined room: ${roomId}`);
      socket.to(roomId).emit("userJoined", { email });

      io.to(roomId).emit("userList", [...new Set(chatRooms[roomId].map((msg) => msg.from))]);

      callback?.({ status: "ok" });
      socket.emit("chatHistory", chatRooms[roomId]);
    });

    socket.on("sendMessage", ({ roomId, from, text }, cb) => {
      const message = { from, text, timestamp: new Date().toISOString() };
      chatRooms[roomId].push(message);

      io.to(roomId).emit("receiveMessage", message);
      cb?.({ status: "ok" });
    });

    socket.on("typing", ({ roomId, email }) => {
      socket.to(roomId).emit("typing", { email });
    });

    socket.on("startLive", ({ roomId, email }) => {
      io.emit("newLiveStarted", { roomId, email });
      console.log(`${email} started live in ${roomId}`);
    });

    socket.on("disconnect", () => {
      console.log("🔴 Client disconnected:", socket.id);
    });
  });
};
