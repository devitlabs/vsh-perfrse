import 'package:flutter/material.dart';
import '../../../../constants/constant_double.dart';
import '../../../../widgets/custom_text.dart';
import 'widgets/suivi_details/collecte_globale_filiale.dart';
import 'widgets/suivi_details/section_suivi.dart';
import 'widgets/contributeur/liste_contributeur.dart';

class OverviewPilotage extends StatelessWidget {
  const OverviewPilotage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5,child: Column(
          children: [
            SectionSuivi(),
            SizedBox(height: defaultPadding),
            ListeContributeur()
          ],
        )),
        SizedBox(width: defaultPadding),
        SizedBox(width: 320,height: 400,child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Progrès de collecte",weight: FontWeight.bold,),
            SizedBox(height: defaultPadding),
            CollecteGlobaleEntites()
          ],
        ),),
        SizedBox(width: defaultPadding),
      ],
    );
  }
}
