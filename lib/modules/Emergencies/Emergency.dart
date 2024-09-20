import 'package:safe_sprout/modules/Emergencies/AmbulanceEmergency.dart';
import 'package:safe_sprout/modules/Emergencies/PoliceEmergency.dart';
import 'package:safe_sprout/modules/Emergencies/FirebrigadeEmergency.dart';
import 'package:safe_sprout/modules/Emergencies/GeneralEmergency.dart';
import 'package:safe_sprout/modules/Emergencies/WomenEmergency.dart';
import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          WomenEmergency(),
          PoliceEmergency(),
          AmbulanceEmergency(),
          FirebrigadeEmergency(),
          GeneralEmergency(),
        ],
      ),
    );
  }
}
