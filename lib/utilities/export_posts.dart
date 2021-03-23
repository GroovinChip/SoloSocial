import 'package:solo_social/library.dart';
import 'package:path/path.dart' as p;
import 'package:csv/csv.dart' as csv;

class ExportPosts {
  final DateFormat dateFormat = DateFormat.yMd().add_jm();
  final List<StorageInfo> storageInfo;

  ExportPosts(
    this.storageInfo,
  );

  Future<String> get localPath async {
    final externalDir = storageInfo[0];
    final dataDir = Directory(p.join(externalDir.rootDir, 'SoloSocial'));
    await dataDir.create(recursive: true);
    return dataDir.path;
  }

  Future<File> get localFile {
    return localPath.then((path) => File(p.join(path, 'SoloSocial Post Records.csv')));
  }

  /// Export user's posts to a readable CSV file
  Future<void> postsToCsv(QuerySnapshot posts) async {
    // Headers
    List<List<String>> data = [
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
    final file = await localFile;

    // Convert data to csv format
    final csvData = csv.ListToCsvConverter().convert(data);

    // Write csv to internal storage
    await file.writeAsString(csvData, flush: true);
  }

  void shareFile() async {
    File postRecords = await localFile;
    ShareExtend.share(postRecords.path, 'file');
  }
}