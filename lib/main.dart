// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:zoom_clone/Features/Authentication/Riverpod/providers.dart';
// import 'package:zoom_clone/Features/Authentication/Screens/authentication_screen.dart';

// import 'package:zoom_clone/Features/Meetings/Screens/main_bottom_navigation.dart.dart';
// import 'package:zoom_clone/Constant/error.dart';

// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();  
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//    GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: "YOUR_GOOGLE_CLIENT_ID",
//   );
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authenticationState = ref.watch(authStateProvider);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Zoom Clone',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       home: authenticationState.when(
//         data: (data) {
//           if (data != null) {
//             return const ButtomNavigationTabs();
//           }
//           return const AuthenticationScreen();
//         },
//         error: (error, stackTrace) => ErrorScreen(
//           errorText: error.toString(),
//         ),
//         loading: () => const CircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zoom_clone/Features/Authentication/Riverpod/providers.dart';
import 'package:zoom_clone/Features/Authentication/Screens/authentication_screen.dart';
// import 'package:zoom_clone/Features/Meetings/Screens/main_bottom_navigation.dart';
import 'package:zoom_clone/Constant/error.dart';
import 'package:zoom_clone/Features/Meetings/Screens/main_bottom_navigation.dart.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get available cameras before running the app
  final cameras = await availableCameras();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "273857954256-3ghrlk1a2ngnqi07j3hnqtmh90i9qa9v.apps.googleusercontent.com",
  );

  runApp(ProviderScope(child: MyApp(cameras: cameras)));
}

class MyApp extends ConsumerWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'talkhub',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: authenticationState.when(
        data: (data) {
          if (data != null) {
            return ButtomNavigationTabs(cameras: cameras); // Pass cameras
          }
          return const AuthenticationScreen();
        },
        error: (error, stackTrace) => ErrorScreen(
          errorText: error.toString(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

