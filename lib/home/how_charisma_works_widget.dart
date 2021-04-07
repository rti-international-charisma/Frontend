import 'package:flutter/material.dart';

class HowCharismaWorks extends StatelessWidget {
  const HowCharismaWorks({Key? key, this.data, this.apiBaseUrl})
      : super(key: key);

  final data;
  final apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            itemCount: data['charisma_steps'].length,
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
                          "$apiBaseUrl/assets/${data['charisma_steps'][index]['number_image']['id']}",
                        ),
                        new Image.network(
                          "$apiBaseUrl/assets/${data['charisma_steps'][index]['number_background_image']['id']}",
                        ),
                        Positioned(
                          bottom: 20,
                          left: 30,
                          child: Text(
                            data['charisma_steps'][index]['id'].toString(),
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
                    if (index == 3)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['charisma_steps'][index]['text'],
                            key: ValueKey('Step${index + 1}Text'),
                            style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                          ),
                          Text(
                            data['charisma_steps'][index]['sub_text'],
                            key: ValueKey('Step${index + 1}SubText'),
                            style:
                                TextStyle(fontSize: 12, fontFamily: 'Roboto'),
                          ),
                        ],
                      )
                    else
                      Flexible(
                        child: Text(
                          data['charisma_steps'][index]['text'],
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
