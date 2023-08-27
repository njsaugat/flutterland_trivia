import 'package:flutterland_trivia/views/home_screen.dart';
import 'package:flutterland_trivia/views/login_page.dart';
import 'package:flutterland_trivia/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/email_model.dart'; // Import the EmailModel
import 'package:provider/provider.dart'; // Import the provider package

// import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      // const MyApp(),
      ChangeNotifierProvider(
    create: (context) => AppData(), // Provide the created data model
    child: MyApp(),
  ));
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutterland Trivia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Set the initial route
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage()
      },
      // home: const HomePage(),
    );
  }
}
