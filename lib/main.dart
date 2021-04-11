import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/api_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await ExportUtility.initialize();

  await Sentry.init(
    (options) {
      options.dsn = ApiKeys.sentryDsn;
    },
    appRunner: () => runApp(SoloSocialApp()),
  );
}

class SoloSocialApp extends StatefulWidget {
  @override
  _SoloSocialAppState createState() => _SoloSocialAppState();
}

class _SoloSocialAppState extends State<SoloSocialApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Bloc>(create: (_) => Bloc()),
      ],
      child: Wiredash(
        navigatorKey: _navigatorKey,
        projectId: ApiKeys.snapfeedProjectId,
        secret: ApiKeys.snapfeedSecret,
        options: WiredashOptionsData(),
        theme: WiredashThemeData(
          primaryColor: Colors.indigo,
          //teaserTitle: 'Hi there!',
          //teaserMessage: 'If you have any issues or suggestions about SoloSocial, we\'d love to hear about it.',
        ),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'SoloSocial',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            primaryColor: Colors.indigo,
            accentColor: Colors.indigoAccent,
            brightness: Brightness.dark,
            canvasColor: Colors.indigo[800],
            textTheme: GoogleFonts.openSansTextTheme(
              Theme.of(context).textTheme,
            ),
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: Colors.indigoAccent,
            ),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.indigo,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.indigo,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              filled: true,
              fillColor: Colors.indigo,
            ),
          ),
          home: AuthCheck(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
