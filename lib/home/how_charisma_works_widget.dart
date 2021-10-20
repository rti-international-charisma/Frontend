import 'package:charisma/constants.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HowCharismaWorks extends StatelessWidget {
  const HowCharismaWorks({
    Key? key,
    this.data,
    this.assetsUrl,
    this.scrollToPageBottom,
  }) : super(key: key);

  final data;
  final assetsUrl;
  final Function? scrollToPageBottom;

  @override
  Widget build(BuildContext context) {
    (data as List).sort((prevStep, nextStep) =>
        prevStep['stepNumber'].compareTo(nextStep['stepNumber']));

    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    handleStepTap(int stepNumber) {
      switch (stepNumber) {
        case 1:
          routerDelegate.replace(HALandingPageConfig);
          break;
        case 2:
          scrollToPageBottom!();
          break;
        case 3:
          routerDelegate.replace(MalePartnerInfoConfig);
          break;
        case 4:
          routerDelegate.replace(ReferralsConfig);
          break;
      }
    }

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
                InkWell(
                  key: ValueKey('Step${index + 1}'),
                  onTap: () {
                    handleStepTap(data[index]['stepNumber']);
                  },
                  child: Container(
                    height: 80,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        new Container(
                          width: 80.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
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
                                  key: ValueKey('StepNumber${index + 1}'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
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
                  ),
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
