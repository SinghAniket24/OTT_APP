import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

// Import your screens here
import 'screens/news_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile.dart';
import 'login_screen.dart';
import 'screens/subscriptions.dart';
import 'screens/library_page.dart';
import 'dart:ui';
import 'screens/settings.dart';
import 'contact.dart';
import 'chatbot_page.dart';
// import 'screens/chat_page.dart' ;
import 'screens/badges_dashboard.dart';
import 'screens/watchparty.dart';


// import 'screens/games_page.dart'; 




void main() async {
  SendbirdChat.init(appId: '5D630797-111E-4F37-B734-8279516F46AB');


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDa6dT-xfaCdnMPPMbTd4yI80v6JqRewU4",
      authDomain: "ott-platform-5bb8a.firebaseapp.com",
      projectId: "ott-platform-5bb8a",
      storageBucket: "ott-platform-5bb8a.firebasestorage.app",
      messagingSenderId: "612360827492",
      appId: "1:612360827492:web:684e5a5f3d61c50f496571",
      measurementId: "G-TXNV05T74J",
    ),
  );

  runApp(const OTTApp());
}

class OTTApp extends StatelessWidget {
  const OTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marathi Play',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF116466),
          secondary: const Color(0xFFD9B08C),
          background: const Color(0xFF23272F),
          surface: const Color(0xFF2C3531),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF23272F),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
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

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const SubscriptionPage(),
    const NewsScreen(),
    LibraryPage(),
    BadgeDashboard(),
    WatchParty(),
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _gradientController = AnimationController(
    duration: const Duration(seconds: 6),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAnimatedGradientAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final t = _gradientController.value;
          return AppBar(
            elevation: 8,
            shadowColor: Colors.black45,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(const Color(0xFF116466), const Color(0xFF00C9A7), t)!,
                    Color.lerp(const Color(0xFF23272F), const Color(0xFF2C3531), 1 - t)!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Text('Marathi play'),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
          );
        },
      ),
    );
  }

  // Enhanced DrawerHeader with gradient and better alignment
  Widget _buildDrawerHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF116466),
            Color(0xFF23272F),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF00F0FF),
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 33,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  color: Color(0xFF116466),
                  size: 55,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced DrawerItem with color on tap and better padding
  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: const Color(0xFF00F0FF).withOpacity(0.16),
        highlightColor: const Color(0xFF00F0FF).withOpacity(0.10),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            leading: Icon(icon, color: Colors.white, size: 26),
            title: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
          ),
        ),
      ),
    );
  }

  // Glassmorphism effect for BottomNavigationBar (unchanged)
  Widget _buildGlassmorphicNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            color: Colors.black.withOpacity(0.28),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent,
              selectedFontSize: 13,
              unselectedFontSize: 11,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library),
                  label: "Library",
                ),
                BottomNavigationBarItem(
  icon: Icon(Icons.emoji_events_rounded),
  label: "Badges",
),
BottomNavigationBarItem(
    icon: Icon(Icons.group),
    label: "WatchParty",
  ),




              ],
            ),
          ),
        ),
      ),
    );
  }

  // AnimatedSwitcher with fade and slide transition
  Widget _buildAnimatedBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.04),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: _pages[_selectedIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: _buildAnimatedGradientAppBar(),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF23272F),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 120,
                child: _buildDrawerHeader(),
              ),
              const SizedBox(height: 6),
              _buildDrawerItem(
                icon: Icons.account_circle,
                label: 'Profile',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
_buildDrawerItem(
  icon: Icons.settings,
  label: 'Settings',
  onTap: () {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  },
),
_buildDrawerItem(
  icon: Icons.chat,
  label: 'Chat',
  onTap: () {
    Navigator.of(context).pop(); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatbotPage()),
    );
  },
),



              _buildDrawerItem(
                icon: Icons.info,
                label: 'About Us',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: Color(0xFF00F0FF),
                  thickness: 0.7,
                  height: 20,
                ),
              ),
              _buildDrawerItem(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: Color(0xFF00F0FF),
                  thickness: 0.7,
                  height: 20,
                ),
              ),
              _buildDrawerItem(
                icon: Icons.phone ,
                label: 'Contact us',
             onTap: () {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ContactPage()),
    );
  },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      body: _buildAnimatedBody(),
      bottomNavigationBar: _buildGlassmorphicNavBar(),
    );
  }
}
