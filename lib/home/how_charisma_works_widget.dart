import 'package:flutter/material.dart';

class HowCharismaWorks extends StatelessWidget {
  const HowCharismaWorks({Key? key, this.data, this.assetsUrl})
      : super(key: key);

  final data;
  final assetsUrl;

  @override
  Widget build(BuildContext context) {
    (data as List).sort((prevStep, nextStep) =>
        prevStep['stepNumber'].compareTo(nextStep['stepNumber']));

    return Column(
      key: ValueKey('CharismaSteps'),
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(20),
          child: Text(
            'How Charisma works',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 400,
          child: new ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) => Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Stack(
                      children: [
                        new Image.network(
                          "$assetsUrl${data[index]['imageUrl']}",
                        ),
                        new Image.network(
                          "$assetsUrl${data[index]['backgroundImageUrl']}",
                        ),
                        Positioned(
                          bottom: 20,
                          left: 32,
                          child: Text(
                            (index + 1).toString(),
                            key: ValueKey('Step${index + 1}'),
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
                        data[index]['title'],
                        key: ValueKey('Step${index + 1}Text'),
                        style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
