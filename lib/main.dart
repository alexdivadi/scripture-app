import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'collections/scripture.dart';

Future<Map<String, dynamic>> fetchScripture(String reference) async {
  final response = await http
      .get(Uri.parse('https://bible-api.com/$reference'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load scripture');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
      [ScriptureSchema],
      directory: dir.path,
      inspector: true);
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Scripture App', isar: isar),
    );
  }
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
  Widget build(BuildContext context) {
    return ListTile(
        selected: isSelected,
        onTap: (){
          if (false){
            // if any other tiles are selected, allow multiple select
            // stretch goal
            /*setState(() {
              selectedTiles[index].selected = !selectedTiles[index].selected;
            });*/
          } else {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(widget.data.text),),
                          Text(widget.data.reference),
                        ]
                      )
                    ],
                  );
                }
            );
          }
        },
        /*onLongPress: (){
          setState(() {
            isSelected = true;
          });
        },*/
        title: Text(widget.data.reference),
      );
    }
}

class ScriptureForm extends StatefulWidget {
  final Isar isar;
  const ScriptureForm({super.key, required this.isar});

  @override
  ScriptureFormState createState() {
    return ScriptureFormState();
  }
}
class ScriptureFormState extends State<ScriptureForm> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  late String display;

  void getResult(String text) async {
    List<String> result = text.split(',');
    if (result.isEmpty) {
      display = "Error getting scripture";
      return;
    }

    for (int i = 0; i < result.length; i++) {
      try {
        final json = await fetchScripture(result[i]);

        final newScripture = Scripture()
          ..reference = json['reference']
          ..text = json['text']
          ..translation = json['translation_name'];

        await widget.isar.writeTxn(() async {
          await widget.isar.scriptures.put(newScripture);
        });
        display = "Added ${result[i]}";
      } catch (e) {
        display = "A scripture was not found";
        break;
      }
    }

  }

  @override
  void initState() {
    super.initState();
    display = "Running";
  }
  
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: myController,
            decoration: const InputDecoration(
              labelText: "Enter comma-separated list of Scriptures",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, ...
                  getResult(myController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(display)),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  final Isar isar;
  const MyHomePage({super.key, required this.title, required this.isar});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Scripture>> scriptureList;

  @override
  void initState() {
    super.initState();
    scriptureList = refreshScriptureList();
  }

  Future<List<Scripture>> refreshScriptureList () async {
    return await widget.isar.scriptures.filter()
        .listNameMatches("default")
        .findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                scriptureList = refreshScriptureList();
              });
              _pushScreen();
            },
            icon: const Icon(Icons.list),
            tooltip: 'Scriptures',
          ),
        ],
      ),
      body: Padding (
            padding: const EdgeInsets.all(32),
            child: Column(
            children: [
              Expanded(child: scriptureWidget()),
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Add a Scripture"),
                          content: ScriptureForm(isar: widget.isar),
                        );
                      });
                  setState(() {
                    scriptureList = refreshScriptureList();
                  });
                },
                child: const Icon(Icons.add),
              )
          ],
          ),
      ),
    );
  }

  Widget scriptureWidget() {
    return FutureBuilder<List<Scripture>>(
      future: scriptureList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FutureItemTile(data: snapshot.data![index]);
              }
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void _pushScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Saved"),
            ),
            body: Center(
              child: FutureBuilder<List<Scripture>>(
                  future: scriptureList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data![0].reference);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  }
            ),
          ),
        );
        }
      )
    );
  }
}
