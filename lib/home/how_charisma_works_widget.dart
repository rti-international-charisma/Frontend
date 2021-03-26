import 'package:flutter/material.dart';

class HowCharismaWorks extends StatelessWidget {
  const HowCharismaWorks({Key? key, this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(20),
          child: Text(
            data!['textContent']['howCharismaWorks'],
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Stack(
              children: [
                new Image.network(
                  "${data['assets']['stepImage'][0]['url']}",
                ),
                new Image.network(
                  "${data['assets']['stepImage'][1]['url']}",
                ),
                Positioned(
                  bottom: 20,
                  left: 30,
                  child: Text(
                    '1',
                    key: ValueKey('Step1'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                "${data['textContent']['step1']}",
                key: ValueKey('Step1Text'),
                style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Stack(
              children: [
                new Image.network(
                  "${data['assets']['stepImage'][2]['url']}",
                ),
                new Image.network(
                  "${data['assets']['stepImage'][3]['url']}",
                ),
                Positioned(
                  bottom: 20,
                  left: 30,
                  child: Text(
                    '2',
                    key: ValueKey('Step2'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                "${data['textContent']['step2']}",
                key: ValueKey('Step2Text'),
                style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Stack(
              children: [
                new Image.network(
                  "${data['assets']['stepImage'][4]['url']}",
                ),
                new Image.network(
                  "${data['assets']['stepImage'][5]['url']}",
                ),
                Positioned(
                  bottom: 20,
                  left: 30,
                  child: Text(
                    '3',
                    key: ValueKey('Step3'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                "${data['textContent']['step3']}",
                key: ValueKey('Step3Text'),
                style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Stack(
              children: [
                new Image.network(
                  "${data['assets']['stepImage'][6]['url']}",
                ),
                new Image.network(
                  "${data['assets']['stepImage'][7]['url']}",
                ),
                Positioned(
                  bottom: 20,
                  left: 30,
                  child: Text(
                    '4',
                    key: ValueKey('Step4'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data['textContent']['step4']}",
                  key: ValueKey('Step4Text'),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                ),
                Text(
                  "${data['textContent']['step4SubText']}",
                  key: ValueKey('Step4SubText'),
                  style: TextStyle(fontSize: 12, fontFamily: 'Roboto'),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
