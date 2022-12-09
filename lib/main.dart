import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

storeText(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('text', text);
}
Future<String> loadText() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString('text') ?? "Nothing stored";
  return stringValue;
}

Future<List<Scripture>> getScriptureList() async {
  List<Scripture> scriptureList = [
    await fetchScripture("col1:17"),
    await fetchScripture("john3:16"),
  ];
  return scriptureList;
}

Future<Scripture> fetchScripture(String reference) async {
  final response = await http
      .get(Uri.parse('https://bible-api.com/$reference'));

  if (response.statusCode == 200) {
    return Scripture.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load scripture');
  }
}

class Scripture{
  final String reference;
  final String text;
  final String translationName;

  const Scripture({
    required this.reference,
    required this.text,
    required this.translationName,
  });

  factory Scripture.fromJson(Map<String, dynamic> json) {
    return Scripture(
      reference: json['reference'],
      text: json['text'],
      translationName: json['translation_name'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Scripture App'),
    );
  }
}

class ScriptureItem extends StatefulWidget {
  final String text;
  final String reference;

  const ScriptureItem({Key? key, required this.text, required this.reference}) : super(key: key);

  @override
  ScriptureItemState createState() => ScriptureItemState();
}
class ScriptureItemState extends State<ScriptureItem> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
            value: _value,
            onChanged: (newValue) => setState(() => _value = newValue)),
      title: Text(widget.reference),
      subtitle: Text(widget.text),
    );
  }
}

class ScriptureForm extends StatefulWidget {
  const ScriptureForm({super.key});

  @override
  ScriptureFormState createState() {
    return ScriptureFormState();
  }
}
class ScriptureFormState extends State<ScriptureForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  late String display;

  void getResult(String text) {
    List<String> result = text.split(',');
    display = "Okay! Getting ";

    if (result.length > 1) {
      for (int i = 0; i < result.length - 1; i++) {
        display = "$display${result[i]}, ";
      }
      display = "$display and ${result.last}";
    } else {
      display = "$display ${result.last}";
    }
    display = "$display for you!";
  }

  @override
  void initState() {
    super.initState();
    //getResult(text);
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
                  storeText(myController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(display)),
                  );
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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Scripture>> scriptureList;
  late Future<String> storedText;

  @override
  void initState() {
    super.initState();
    scriptureList = getScriptureList();
    storedText = loadText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _pushScreen,
            icon: const Icon(Icons.list),
            tooltip: 'Scriptures',
          ),
        ],
      ),
      body: Padding (
            padding: const EdgeInsets.all(32),
            child: Column(
            children: [
              const ScriptureForm(),
              Expanded(child: scriptureWidget()),
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
                Scripture scripture = snapshot.data![index];
                return ScriptureItem(text: scripture.text, reference: scripture.reference);
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
              child: FutureBuilder<String>(
                  future: storedText,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
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
