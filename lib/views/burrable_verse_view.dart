import 'dart:math';

import 'package:blur/blur.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class BlurPage extends StatefulWidget {
  const BlurPage({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  _BlurPageState createState() => _BlurPageState();
}

class _BlurPageState extends State<BlurPage> {
  //double blurValue = 10;
  double blurValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            (blurValue == 0.0) ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.text),
            ) : Wrap(
                children:
                widget.text.split(' ').map((e) {
                  return MyBlur(e, shouldBlur: shouldBlur(blurValue));
                }).toList()
            ),
            ButtonBar(
                children:
                [
                  TextButton(onPressed: () {
                    setState(() {
                      FirebaseAnalytics.instance.logEvent(name: "BlurMoreTapped", parameters: {'blurValue': blurValue});
                      FirebaseAnalytics.instance.setUserProperty(name: "HasBlurred", value: "true");
                      if (blurValue == 0) {
                        // make sure at least one word is blurred when you start.
                        blurValue = 2;
                      } else {
                        blurValue++;
                      }
                    });
                  }, child: Text(getBlurMoreText(blurValue)),),
                  TextButton(onPressed: () {
                    setState(() {
                      FirebaseAnalytics.instance.logEvent(name: "BlurLessTapped", parameters: {'blurValue': blurValue});

                      blurValue--;
                    });
                  }, child: Text(getBlurLessText(blurValue)),),

                ]
            )

          ],
        ),
      );
  }
}
String getBlurMoreText(double blurValue) {
  if (blurValue == 0) return 'Blur';
  if (blurValue == 100) return '';
  return 'Blur more';
}

String getBlurLessText(double blurValue) {
  if (blurValue == 0) return '';
  return 'Blur less';
}
bool shouldBlur(double blurValue) => Random().nextInt(20) < blurValue.toInt();

class MyBlur extends StatelessWidget {
  const MyBlur(this.text, {Key? key, this.shouldBlur = true}) : super(key: key);

  final String text;
  final bool shouldBlur;
  @override
  Widget build(BuildContext context) => Blur(
    blur: shouldBlur ?  3.2 : 0,
    blurColor: Theme.of(context).primaryColor,
    child: Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          border: Border.all(color: Colors.green),
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(color: Colors.white),),
    ),
  );
}
