import 'package:solo_social/library.dart';
import 'package:sentry/sentry.dart';
import 'package:solo_social/utilities/api_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SoloSocialApp());
}

class SoloSocialApp extends StatefulWidget {
  @override
  _SoloSocialAppState createState() => _SoloSocialAppState();
}

class _SoloSocialAppState extends State<SoloSocialApp> {
  SentryClient sentry = SentryClient(dsn: ApiKeys.sentryDsn);

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
        Provider<SentryClient>(create: (_) => sentry),
        Provider<PackageInfo>(create: (_) => _packageInfo),
      ],
      child: Snapfeed(
        projectId: ApiKeys.snapfeedProjectId,
        secret: ApiKeys.snapfeedSecret,
        child: MaterialApp(
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
