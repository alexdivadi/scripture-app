import 'dart:math';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class BlurPage extends StatefulWidget {
  const BlurPage({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  _BlurPageState createState() => _BlurPageState();
}

class _BlurPageState extends State<BlurPage> {
  double blurValue = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Wrap(
                children:
                'He is before all things and in him all things hold together'.split(' ').map((e) {
                  return MyBlur(e, shouldBlur: shouldBlur(blurValue));
                }).toList()
            ),
            ButtonBar(
                children:
                [
                  TextButton(onPressed: () {
                    setState(() {
                      blurValue++;
                    });
                  }, child: const Text('Blur More'),),
                  TextButton(onPressed: () {
                    setState(() {
                      blurValue--;
                    });
                  }, child: const Text('Blur Less'),),

                ]
            )

          ],
        ),
      );
  }
}

bool shouldBlur(double blurValue) => Random().nextInt(20) < blurValue.toInt();

class MyBlur extends StatelessWidget {
  const MyBlur(this.text, {Key? key, this.shouldBlur = true}) : super(key: key);

  final String text;
  final bool shouldBlur;
  @override
  Widget build(BuildContext context) => Blur(
    blur: shouldBlur ?  3.2 : 0,
    blurColor: Colors.white,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    ),
  );
}
