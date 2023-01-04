
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:isar/isar.dart';
import 'package:scripture_app/providers.dart';
import 'package:scripture_app/scripture_form.dart';
import 'package:scripture_app/views/scripture_dialog.dart';
import 'collections/scripture.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

var log = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
  ),
);

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  analytics.setUserProperty(name: "isDebug", value: kDebugMode.toString());
  Duration minimumFetchInternal = const Duration(hours: 12);
  if (kDebugMode) {
    // TODO: Consider purpose of push and permissiosn and fcm channel and icon
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log.d('fcmToken = $fcmToken');
    // note test FCM not working under my pixel 6 yet
    // but can return later, not needed right now.
    minimumFetchInternal = const Duration(seconds: 1);
  }
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: minimumFetchInternal,
  ));
  await remoteConfig.fetchAndActivate();
  String csv = remoteConfig.getString("first_install_list");
  log.d('csv=$csv');


  final container = ProviderContainer();
  final database = container.read(databaseProvider);
  await database.init();


  // if entire database emprty like first install, and there's a remote list, use a remote lixst
  if (csv.isEmpty) {
    // even if issue with firebase, give some scriptures
    csv = 'Col 1:17, Matt 6:33, Phil 4:13';
  }
  int numScriptures = await database.getScriptureCount();
  log.d('numScriptures=$numScriptures');
  // this is pretty safe, default list is only loaded when entire db empty
  // so as long as db is not empty "My List" can be renamed/modified etc
  if (numScriptures == 0) {
      // TODO: Clean this up a bit to happen within an initDatabase or similar)
      await container.read(getResultProvider.call(csv, 'My List').future);
  }


  String collectionNamesCsv = remoteConfig.getString("collectionNamesCsv");
  collectionNamesCsv.split(',').forEach((e) async {
    String collectionName = e.trim();
    // Word Of God" would be "Word_of_God" bc can't have space in remote config it looks like
    String collectionCsv = remoteConfig.getString(collectionName.replaceAll(" ", "_"));
    if (collectionCsv.isNotEmpty) {
      bool isEmpty = (await database.isListEmpty(collectionName));
      if (isEmpty) {
        await container.read(getResultProvider.call(collectionCsv, collectionName).future);
      }
    }
  });


  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Our Verses',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MyHomePage(title: 'Scripture App'),
    );
}

class FutureItemTile extends StatefulWidget {
  final Scripture data;
  const FutureItemTile({super.key, required this.data});

  @override
  _FutureItemTileState createState() => _FutureItemTileState();
}
class _FutureItemTileState extends State<FutureItemTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) => ListTile(selected: isSelected,
        onTap: () => showDialog<String>(context: context,
                builder: (BuildContext context) => VerseDialog(scripture: widget.data)
            ),
        title: Text(widget.data.reference),
    );
}

class MyHomePage extends StatefulHookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Future<List<Scripture>>? scriptureList;
  // TODO: maybe use shared_preferences to store the last list opened whenever app is closed

  // TODO: Finish abstracting this out so no longer tightly coupled.
  Isar get isar => database.isar;
  Database get database => ref.read(databaseProvider);
  @override
  void initState() {
    getInitialList();
    super.initState();
  }

  void getInitialList() {
    isar.scriptures.where().listNameProperty().findFirst().then((value) {
      ref.read(currentListProvider.notifier).setCurrentList(value ?? "My List");
      refreshScriptureList();
    }
    );
  }

  // TODO: Get rid of setState() calls when rebuild happens bc riverpod which is most of them.
  Future<List<Scripture>> getScriptureList (String listName) async {
    return await isar.scriptures.filter()
        .listNameMatches(listName)
        .findAll();
  }


  void refreshScriptureList() {
    scriptureList = getScriptureList(ref.watch(currentListProvider));
    setState(() {});
  }

  Future<List<String>> getCollections () async {
    return await isar.scriptures.where()
    .distinctByListName()
        .listNameProperty()
        .findAll();
  }

  void switchCollections (String newList) async {
    analytics.logEvent(name: "SwitchedCollection");
    scriptureList = getScriptureList(newList);
    ref.read(currentListProvider.notifier).setCurrentList(newList);
  }

  @override
  Widget build(BuildContext context) {
    // The hook "useTextEditingController" handles disposing it when finished.
    TextEditingController newNameController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushCollectionsScreen,
            tooltip: 'Your Collections',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Padding (
            padding: const EdgeInsets.all(32),
            child: Column(
            children: [
              Container(padding: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      ref.watch(currentListProvider),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 30,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit collection name',
                      onPressed: () async {
                        String? newName =  await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Edit List Name?'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('New name:'),
                              TextField(controller: newNameController,)
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                log.d('new name = ${newNameController.text}');
                                Navigator.pop(context, newNameController.text.trim());
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
                      if (newName != null) {
                        await renameList(newName);
                      }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: scriptureWidget()),
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () async {
                  analytics.logEvent(name: "TappedAddButton");
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SimpleDialog(
                          title: Text("Add a Scripture"),
                          children: [
                            Padding(padding: EdgeInsets.all(20),
                              child: ScriptureForm(),
                            )],
                        );
                      }
                  );
                },
                tooltip: 'Add a verse',
                child: const Icon(Icons.add),
              )
          ],
          ),
      ),
    ),
    );
  }

  Future<void> renameList(String newName) async {
    String oldName = ref.read(currentListProvider);
    log.d('update db with newNmae = $newName');
    await database.renameList(oldName, newName);
    ref.read(currentListProvider.notifier).setCurrentList(newName);
  }
  Future<void> _pullRefresh() async {
    analytics.logEvent(name: "PullToRefresh");
    scriptureList = getScriptureList(ref.read(currentListProvider));
    setState((){});
  }

  Future<void> _pushCollectionsScreen() async {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            return collectionWidget();
          }
        )
    );
  }

  // List of collections (tappable)
  Widget collectionWidget() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      body: FutureBuilder<List<String>>(
        future: getCollections(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // TODO: maybe throw in an asPascalCase
                    title: Text(snapshot.data![index]),
                    enabled: (snapshot.data![index] != ref.watch(currentListProvider)),
                    onTap: () async {
                      switchCollections(snapshot.data![index]);
                      Navigator.of(context).pop();
                    },
                  );
                }

            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  // List of scriptures (tappable + slidable)
  Widget scriptureWidget() {
    return FutureBuilder<List<Scripture>>(
      future: scriptureList,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                //TODO: replace Slidable with better widget
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        analytics.logEvent(name: "DeleteSlideAction");
                        await isar.writeTxn(() async {
                          await isar.scriptures.delete(
                              snapshot.data![index].scriptureId);
                        });
                        refreshScriptureList();
                      },
                    ),
                  ],
                  child: FutureItemTile(data: snapshot.data![index]),
                );
              }
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

}
