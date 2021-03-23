import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/api_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

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
  PackageInfo _packageInfo;
  String appName;
  String packageName;
  String version;
  String buildNumber;

  /// Retrieve information about this app for display
  void _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    appName = _packageInfo.appName;
    packageName = _packageInfo.packageName;
    version = _packageInfo.version;
    buildNumber = _packageInfo.buildNumber;
  }

  @override
  void initState() {
    _getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Bloc>(create: (_) => Bloc()),
        Provider<PackageInfo>(create: (_) => _packageInfo),
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
            textSelectionHandleColor: Colors.indigoAccent,
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
