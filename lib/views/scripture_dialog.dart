import 'package:flutter/material.dart';
import 'package:scripture_app/views/burrable_verse_view.dart';
import 'package:share_plus/share_plus.dart';

import '../collections/scripture.dart';

class VerseDialog extends StatelessWidget {
  const VerseDialog({Key? key, required this.scripture}) : super(key: key);

  final Scripture scripture;
  String get reference => scripture.reference;
  String get translation => scripture.translation;
  String get text => scripture.text;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Column(children: [
              Row(children: [
                  Expanded(
                    child: Padding(padding: const EdgeInsets.only(left: 10.0),
                      child: Text("$reference \n($translation)", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    ),),
                  Container(alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Share.share("$text\n$reference ($translation)"),
                      icon: const Icon(Icons.share),
                      iconSize: 30,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ],
              ),
              BlurPage(text: text),
              //Padding(padding: const EdgeInsets.all(10), child: Text("$text\n", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
            ]
        )
      ],
    );
  }
}
