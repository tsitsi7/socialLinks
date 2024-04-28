import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialLinks/providers/user_provider.dart';
import 'package:socialLinks/responsive/mobile_screen_layout.dart';
import 'package:socialLinks/responsive/responsive_layout.dart';
import 'package:socialLinks/responsive/web_screen_layout.dart';
import 'package:socialLinks/screens/login_screen.dart';
import 'package:socialLinks/utils/colors.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform
        //   options: const FirebaseOptions(
        //
        //       apiKey: "AIzaSyDEi9Rp3KsaezE0J2nq0onSGbO6tMxxJAA",
        //       appId: "1:858505248896:android:0d638449588c3946466665",
        //       messagingSenderId: "585119731880",
        //       projectId: "cw07-f3d73",
        //       storageBucket:
        //           'https://console.firebase.google.com/u/0/project/cw07-f3d73/storage/cw07-f3d73.appspot.com/files'),
        //
        //
        );
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Links',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
