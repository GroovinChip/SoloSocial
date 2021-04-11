import 'package:csv/csv.dart' as csv;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:solo_social/library.dart';

final DateFormat dateFormat = DateFormat.yMd().add_jm();

class ExportUtility {
  ExportUtility._();

  static final ExportUtility instance = ExportUtility._();

  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      _storageDir = await path_provider.getExternalStorageDirectory();
    } else {
      _storageDir = await path_provider.getApplicationDocumentsDirectory();
    }
  }

  static Directory? _storageDir;

  static Future<String> get _localPath async {
    final dataDir = Directory(p.join(_storageDir!.path, 'SoloSocial'));
    await dataDir.create(recursive: true);
    return dataDir.path;
  }

  static Future<File> get _localFile {
    return _localPath
        .then((path) => File(p.join(path, 'SoloSocial Post Records.csv')));
  }

  /// Export user's posts to a readable CSV file
  Future<void> postsToCsv(QuerySnapshot posts) async {
    // Headers
    List<List<String?>> data = [
      ['Username', 'Time Created', 'Post Text', 'Tags', 'Source Link'],
    ];

    // Add post record to data
    for (final DocumentSnapshot post in posts.docs) {
      data.add([
        post['Username'],
        dateFormat.format((post['TimeCreated'] as Timestamp).toDate()),
        post['PostText'],
        post['Tags'],
        post['SourceLink'],
      ]);
    }
    final file = await _localFile;

    // Convert data to csv format
    final csvData = csv.ListToCsvConverter().convert(data);

    // Write csv to internal storage
    await file.writeAsString(csvData, flush: true);
  }

  Future<void> shareFile() async {
    File postRecords = await _localFile;
    ShareExtend.share(postRecords.path, 'file');
  }
}
