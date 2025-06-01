import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BadgeDashboard extends StatefulWidget {
  @override
  _BadgeDashboardState createState() => _BadgeDashboardState();
}

class _BadgeDashboardState extends State<BadgeDashboard> {
  final userData = {
    "username": "@romcomfan",
    "leaderboardPosition": 4,
    "totalBadges": 3
  };

  final List<Map<String, dynamic>> allBadges = [
    {
      "name": "90s Romcom Guru",
      "description": "Watched 10+ 90s romcoms",
      "earned": true,
    },
    {
      "name": "Trivia Starter",
      "description": "Participated in 1 trivia game",
      "earned": true,
    },
    {
      "name": "Trivia Buff",
      "description": "Participated in 10 trivia games",
      "earned": true,
    },
    {
      "name": "Weekend Binger",
      "description": "Watched 5 shows on a weekend",
      "earned": false,
    },
    {
      "name": "Classic Buff",
      "description": "Watched 5 black & white classics",
      "earned": false,
    },
  ];

  final List<Map<String, dynamic>> leaderboard = [
    {"username": "@filmjunkie", "badges": 7},
    {"username": "@quizqueen", "badges": 6},
    {"username": "@cinemalover", "badges": 5},
    {"username": "@romcomfan", "badges": 3},
    {"username": "@bingehero", "badges": 2},
  ];

  void _shareBadge(String badgeName) {
    final message =
        '🏅 I just unlocked the "$badgeName" badge on OTTZone! ${userData["username"]}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard: $message")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earned = allBadges.where((b) => b["earned"]).toList();
    final locked = allBadges.where((b) => !b["earned"]).toList();

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text("🎖️ Your Badges"),
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _leaderboardCard(),
          SizedBox(height: 20),
          _sectionTitle("🎖️ Earned Badges"),
          ...earned.map((b) => _badgeCard(b, earned: true)).toList(),
          SizedBox(height: 20),
          _sectionTitle("🔒 Locked Badges"),
          ...locked.map((b) => _badgeCard(b, earned: false)).toList(),
          SizedBox(height: 20),
          _sectionTitle("🌍 Global Leaderboard"),
          ...leaderboard.asMap().entries.map((entry) => _leaderboardItem(entry.key, entry.value)).toList(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.tealAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _badgeCard(Map<String, dynamic> badge, {required bool earned}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: earned
            ? LinearGradient(colors: [Color(0xFF1f1f1f), Color(0xFF2b2b2b)])
            : LinearGradient(colors: [Color(0xFF3a3a3a), Color(0xFF4a4a4a)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: earned ? Colors.blue.withOpacity(0.4) : Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(earned ? Icons.verified : Icons.lock,
                  color: earned ? Colors.greenAccent : Colors.grey[500]),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  badge["name"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: earned ? Colors.white : Colors.grey[300],
                  ),
                ),
              ),
              if (earned)
                GestureDetector(
                  onTap: () => _shareBadge(badge["name"]),
                  child: Icon(FontAwesomeIcons.shareNodes,
                      size: 16, color: Colors.tealAccent),
                )
            ],
          ),
          SizedBox(height: 8),
          Text(
            badge["description"],
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: earned ? Colors.grey[300] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaderboardCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🏆 Leaderboard Position: #${userData["leaderboardPosition"]}",
            style: TextStyle(color: Colors.tealAccent, fontSize: 18),
          ),
          SizedBox(height: 4),
          Text(
            "You've earned ${userData["totalBadges"]} badges so far. Keep going!",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _leaderboardItem(int index, Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: index == 0
            ? LinearGradient(colors: [Colors.amber.shade200, Colors.orange.shade300])
            : LinearGradient(colors: [Color(0xFF1f1f1f), Color(0xFF2a2a2a)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "#${index + 1} ${user["username"]}",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            "🏅 ${user["badges"]} badge${user["badges"] > 1 ? "s" : ""}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
