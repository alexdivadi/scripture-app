
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scripture_app/scripture_form.dart';

import 'collections/scripture.dart';
import 'main.dart';

part 'providers.g.dart';


// use https://github.com/dart-lang/build/blob/master/docs/getting_started.md
// dart pub run build_runner watch
// https://pub.dev/packages/riverpod_generator

Future<Map<String, dynamic>> fetchScripture(String reference) async {
  String url = 'https://bible-api.com/$reference';
  Uri uri = Uri.parse(url);

  log.d(uri.toString());
  // TODO: connectivity reminder if no connection
  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      log.d("200 ok");
      return jsonDecode(response.body);
    } else {
      log.e('status code = ${response.statusCode} message = ${response.reasonPhrase}', Exception('Failed to load scripture'));
      throw Exception('Failed to load scripture');
    }
  } catch(e) {
    log.e(e);
    rethrow;
  }


}


// use flutter pub run build_runner watch
// or flutter pub run build_runner build --delete-conflicting-outputs
// Make API call and convert to Scripture

class Database {
  Isar? _isar;
  Isar get isar  {
    if (_isar == null) {
      throw Exception('Must call init first');
    } else {
      return _isar!;
    }
  }


  Database();

  Future<int> getScriptureCount() async {
   return  isar.scriptures.count();
  }

  // TOOD: When database is restructured so there's a foreign key
  // or similar and renaming a list takes only one db row
  // make sure all tests still pass.
  Future<bool> renameList(String oldName, String newName) async {
    await isar.writeTxn(() async {
      List<Scripture> scriptures = await isar.scriptures.where().listNameEqualTo(oldName).findAll();
      // TODO: In future use UDF and immutable classes for most everything
      for (var element in scriptures) {
        element.listName = newName;
      }
      // update all since they already exist.
      await isar.scriptures.putAll(scriptures);
    });
    return true;
  }


  Future<bool> isListEmpty(String listName) async => await (isar.scriptures.where().listNameEqualTo(listName).count()) == 0;

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _isar = await Isar.open(
        [ScriptureSchema],
        directory: dir.path,
        inspector: true);
  }

  Future<void> writeScripture(Scripture scripture) async {
    await isar.writeTxn(() async {
      await isar.scriptures.put(scripture);
    });
  }

}

// see https://codewithandrea.com/articles/flutter-riverpod-data-caching-providers-lifecycle/
@Riverpod(keepAlive:true)
Database database(DatabaseRef ref) => Database();
// making database a singleton with keepAlive true

@riverpod
Future<void> getResult(GetResultRef ref, String text, String currentList) async {
  log.d(text);
  List<String> result = text.split(',');
  if (result.isEmpty) {
    display = "Error getting scripture";
    return;
  }

  for (int i = 0; i < result.length; i++) {
    try {
      String reference = result[i];
      reference = reference.trim(); // uf user pus "John 1:1, John 1:2" we def don't want it to fail bc space.
      final json = await fetchScripture(reference);

      final newScripture = Scripture()
        ..reference = json['reference']
        ..text = json['text']
        ..translation = json['translation_name']
        ..listName = currentList;

      Database database = ref.read(databaseProvider);
      await database.writeScripture(newScripture);


      display = "Added ${result[i]}";
      analytics.logEvent(name: "Added", parameters: {'verse': result[i]});
    } catch (e) {
      display = 'the scripture "$text"" was not found';
      analytics.logEvent(name: "ErrorGettingScripture", parameters: {'textString': text});
      break;
    }
  }

}

@Riverpod(keepAlive: true)
class CurrentList extends _$CurrentList {
  @override
  String build() {
    return 'My List';
  }

  void setCurrentList(String newListName) {
    state = newListName;
  }
}
