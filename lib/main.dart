import 'package:flutter/material.dart';
import 'screens/news_screen.dart';
import 'screens/home_screen.dart'; 
import 'screens/profile.dart';
import 'login_screen.dart';


void main() {
  runApp(const OTTApp());
}

class OTTApp extends StatelessWidget {
  const OTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTT App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF116466),
          secondary: const Color(0xFFD9B08C),
          background: const Color(0xFF2C3531),
          surface: const Color(0xFF2C3531),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF2C3531),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF2C3531),
          selectedItemColor: Color(0xFF00F0FF),
          unselectedItemColor: Colors.white70,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
     HomeScreen(),
    const Center(child: Text("Subscriptions Page", style: TextStyle(color: Colors.white))),
    const NewsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('OTT App'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF116466)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      color: Color(0xFF116466),
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'user@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
           ListTile(
  leading: const Icon(Icons.account_circle, color: Colors.white),
  title: const Text('Profile', style: TextStyle(color: Colors.white)),
  onTap: () {
    // Close the Drawer
    Navigator.of(context).pop();
    
    // Navigate to Profile Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  },
),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('About Us', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Divider(color: Colors.white70),
ListTile(
  leading: const Icon(Icons.logout, color: Colors.white),
  title: const Text('Logout', style: TextStyle(color: Colors.white)),
  onTap: () {
    Navigator.of(context).pop(); // Close the Drawer first
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  },
),

            const Divider(color: Colors.white70),
            ListTile(
              leading: const Icon(Icons.more_horiz, color: Colors.white),
              title: const Text('More', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black.withOpacity(0.3),
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: "Subscriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "News",
          ),
        ],
      ),
    );
  }
}
