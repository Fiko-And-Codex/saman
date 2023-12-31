import 'package:saman/screens/splash_screen.dart';
import 'package:saman/services/user_service.dart';
import 'package:saman/utilities/constants.dart';
import 'package:saman/utilities/event_handlers/app_life_cycle_event_handler.dart';
import 'package:saman/utilities/no_thumb_scrollbar.dart';
import 'package:saman/utilities/providers.dart';
import 'package:saman/view_models/theme/theme_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'options_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  if(!kIsWeb){
    await MobileAds.instance.initialize();
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      AppLifeCycleEventHandler(
        detachedCallBack: () => UserService().setUserStatus(false),
        resumeCallBack: () => UserService().setUserStatus(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {

          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
           
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            home: const SplashScreen(),
            scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
            builder: (context, child) {

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {

    return theme.copyWith(
      textTheme: GoogleFonts.ubuntuTextTheme(
        theme.textTheme,
      ),
    );
  }
}
