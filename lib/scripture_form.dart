import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scripture_app/providers.dart';

import 'main.dart';
class ScriptureForm extends ConsumerStatefulWidget {
  const ScriptureForm({super.key});

  @override
  ScriptureFormState createState() => ScriptureFormState();
}
String display = '';
class ScriptureFormState extends ConsumerState<ScriptureForm> {
  final _formKey = GlobalKey<FormState>();
  final referenceController = TextEditingController();
  TextEditingController collectionController = TextEditingController();
  // TODO: useTextEditingController hook

  @override
  void initState() {
    super.initState();
    display = "Running";
    collectionController = TextEditingController(text: ref.watch(currentListProvider));
  }

  // TODO: Switch to HookConsumerWidget not StatefulWidget
  @override
  void dispose() {
    referenceController.dispose();
    collectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: referenceController,
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
        // TODO: Maybe hide this TextForm unless the user wants to create a new list
        TextFormField(
          controller: collectionController,
          decoration: const InputDecoration(
            labelText: "Collection name",
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
            onPressed: () async {
              debugPrint("**tapped submit");
              analytics.logEvent(name: "AddVerseSubmitButtonTapped");

              if (_formKey.currentState!.validate()) {
                // If the form is valid, ...
                await ref.read(getResultProvider.call(referenceController.text, collectionController.text).future);
                // TODO: address lint warning about async gap
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(display)),
                );

                // TODO: Better fix than this
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    // TODO: gorouter, don't pass around isar, riverpod
                      builder: (context) => const MyHomePage(title: 'Scripture App')
                  ),
                );

              } else {
                debugPrint("**form not valid");
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    ),
  );
}