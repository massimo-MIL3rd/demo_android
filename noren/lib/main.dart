import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noren/login/login_page.dart';
import 'package:noren/shop/shop_page.dart';
import 'package:noren/edit/edit_shop_page.dart';
import 'package:noren/map/map_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // import追加

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = [const MapPage(), LoginPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 2,
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     'デジタルのれん',
      //     // style: TextStyle(fontStyle: FontStyle.italic),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         // 画面遷移
      //         if (FirebaseAuth.instance.currentUser != null) {
      //           print('ログインしている');
      //           await Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => ShopPage(),
      //               fullscreenDialog: true,
      //             ),
      //           );
      //         } else {
      //           print('ログインしていない');
      //           await Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => LoginPage(),
      //               fullscreenDialog: true,
      //             ),
      //           );
      //         }
      //       },
      //       icon: Icon(Icons.person),
      //     ),
      //   ],
      // ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_sharp), label: 'マップ'),
          NavigationDestination(
              icon: Icon(Icons.storefront_sharp), label: 'マイページ'),
        ],
        onDestinationSelected: (int index) async {
          setState(() {
            currentPage = index;
          });
        //    // 画面遷移
        //       if (FirebaseAuth.instance.currentUser != null) {
        //         print('ログインしている');
        //         await Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => ShopPage(),
        //             fullscreenDialog: true,
        //           ),
        //         );
        //       } else {
        //         print('ログインしていない');
        //         await Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => LoginPage(),
        //             fullscreenDialog: true,
        //           ),
        //         );
        //       }
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
