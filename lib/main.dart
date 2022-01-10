import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/local/local_state.dart';
import 'package:mobi/models/details.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/secondary_state.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/onboarding/onboarding_widget.dart';
import 'package:mobi/screens/sign_in_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:mobi/services/dialogs/dialog_manager.dart';
import 'package:mobi/viewmodels/chat_view_model.dart';
import 'package:mobi/viewmodels/locations_model.dart';
import 'package:mobi/viewmodels/payment_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'extras/message_handler.dart';
import 'extras/strings.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'locator.dart';
import 'viewmodels/user_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocator();


  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(SecondaryStateAdapter());
  Hive.registerAdapter(TheLocationAdapter());
  Hive.registerAdapter(CarDetailsAdapter());
  Hive.registerAdapter(SocialAccountsAdapter());
  Hive.registerAdapter(DrivingStateAdapter());
  Hive.registerAdapter(TimeOfDayCustomAdapter());

  //open up hive
  await Hive.openBox(MyStrings.state);

  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  await DotEnv().load('.env');
  final ABSAppStateLocalStorage _localStorage = locator<ABSAppStateLocalStorage>();
  return runApp(MainScreen(observer: observer,storage: _localStorage,));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 200)
    ..indicatorType = EasyLoadingIndicatorType.pulse
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black.withOpacity(0.8)
    ..indicatorColor = Colors.yellow
    ..maskType = EasyLoadingMaskType.black
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false;
}

class MainScreen extends StatelessWidget {
  final FirebaseAnalyticsObserver observer;
  final AppStateBoxStorage storage;



  const MainScreen({Key key,@required this.observer, this.storage}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: OverlaySupport(
        child: MaterialApp(
            title: 'Mobiride',
            navigatorObservers: <NavigatorObserver>[observer],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Nunito',
                textTheme: GoogleFonts.sourceSansProTextTheme(
                  Theme.of(context).textTheme,
                ),
                primaryColor: primaryColor,
                bottomSheetTheme:
                BottomSheetThemeData(backgroundColor: Colors.transparent),

                appBarTheme: AppBarTheme(color: primaryColor)
            ),

            builder: EasyLoading.init(builder: (context, widget) => Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => DialogManager(
                    child: widget,
                  )),
            )),
            // home: storage.getSecondaryState().isLoggedIn == false ? SignInScreen() : MessageHandler(child: HomeTabs(),)
            home: MessageHandler(child: HomeTabs(),)
        ),
      ),
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel(),),
        ChangeNotifierProvider<ABSChatViewModel>(create: (_) => ChatViewModel(),),
        ChangeNotifierProvider<RidesViewModel>(create: (_) => RidesViewModel()),
        ChangeNotifierProvider<LocationModel>(create: (_) => LocationModel()),
        ChangeNotifierProvider<PaymentViewModel>(create: (_) => PaymentViewModel()),
      ],
    );
  }
}
