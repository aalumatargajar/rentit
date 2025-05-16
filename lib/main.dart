import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:rentit/firebase_options.dart';
import 'package:rentit/src/common/const/app_animation.dart';
import 'package:rentit/src/common/utils/shared_preference_helper.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';
import 'package:rentit/src/features/booking/booking_provider.dart';
import 'package:rentit/src/features/bottom_nav/bottom_navbar_provider.dart';
import 'package:rentit/src/features/brands/brands_provider.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:rentit/src/features/splash_screen.dart';
import 'package:rentit/src/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefHelper.getInitialValue();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavbarProvider()),
        ChangeNotifierProvider(create: (context) => BrandsProvider()),
        ChangeNotifierProvider(create: (context) => CarProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.black45,
      overlayWidgetBuilder: (progress) {
        return Center(child: Image.asset(AppAnimation.tyreAnimation));
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.instance.lightTheme,
        home: SplashScreen(),
      ),
    );
  }
}
