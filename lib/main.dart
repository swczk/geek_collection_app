import 'package:flutter/material.dart';
import 'package:geek_collection/pages/collection_page.dart';
import 'package:geek_collection/pages/login_page.dart';
import 'package:geek_collection/pages/register_page.dart';
import 'package:geek_collection/pages/share_page.dart';
import 'package:geek_collection/pages/user_page.dart';
import 'package:geek_collection/services/auth_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingletonAsync<AuthService>(() async => AuthService());
  await getIt.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geek Collections',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const MainScreen();
                } else {
                  return LoginScreen();
                }
              },
            ),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/collections': (context) => const MainScreen(),
      },
    );
  }
}

  Future<bool> _checkLoginStatus() async {
    final authService = getIt<AuthService>();
    final token = await authService.getToken();
    return token != null;
  }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    CollectionsScreen(),
    SharedCollectionsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Shared',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
