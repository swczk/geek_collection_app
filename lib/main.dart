import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/pages/collection_page.dart';
import 'package:geek_collection/pages/login_page.dart';
import 'package:geek_collection/pages/register_page.dart';
import 'package:geek_collection/pages/share_page.dart';
import 'package:geek_collection/pages/user_page.dart';
import 'package:geek_collection/services/auth_service.dart';
import 'package:geek_collection/services/category_service.dart';
import 'package:geek_collection/services/collection_service.dart';
import 'package:geek_collection/services/item_service.dart';
import 'package:geek_collection/services/persistence_service.dart';
import 'package:geek_collection/services/share_service.dart';
import 'package:geek_collection/utils/theme.dart';
import 'package:get_it/get_it.dart';

Future<void> dependency() async {
  final GetIt getIt = GetIt.instance;

  getIt.registerSingletonAsync<PersistenceService>(
      () async => PersistenceService());
  await getIt.isReady<PersistenceService>();

  getIt.registerSingletonAsync<AuthService>(() async => AuthService());
  await getIt.isReady<AuthService>();

  getIt.registerSingletonAsync<ShareService>(() async => ShareService());
  getIt.registerSingletonAsync<ItemService>(() async => ItemService());
  getIt.registerSingletonAsync<CategoryService>(() async => CategoryService());
  getIt.registerSingletonAsync<CollectionService>(
      () async => CollectionService());

  await getIt.allReady();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dependency();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geek Collections',
      debugShowCheckedModeBanner: false,
      theme: DefaultTheme.lightThemeData(context),
      darkTheme: DefaultTheme.darkThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
            future: _checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData && snapshot.data == true) {
                return const MainScreen();
              }
              return LoginScreen();
            }),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/collections': (context) => const MainScreen(),
      },
    );
  }
}

Future<bool> _checkLoginStatus() async {
  final persistenceService = GetIt.I<PersistenceService>();
  final authService = GetIt.I<AuthService>();
  var result = await authService.getToken();
  if (result is Failure) {
    return false;
  }
  var result2 = await authService.isValidToken();
  if (result2 is Failure) {
    await persistenceService.removeToken();
    return false;
  }

  return true;
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
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Collections'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Shared'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
