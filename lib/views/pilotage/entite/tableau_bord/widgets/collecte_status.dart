import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/progress_bar.dart';
import '../../../controllers/tableau_controller.dart';

class CollecteStatus extends StatefulWidget {
  const CollecteStatus({Key? key}) : super(key: key);

  @override
  State<CollecteStatus> createState() => _CollecteStatusState();
}

class _CollecteStatusState extends State<CollecteStatus> {

  final TableauBordController tableauBordController = Get.find();

  Map getInfosTableau(List<dynamic> dataValeursTableau,int month) {

    var list = [];
    for (var data in dataValeursTableau) {
      if (data[month] != null ) {
        list.add(data[month]);
      }
    }
    num? ratio = (list.length / dataValeursTableau.length ).toDouble();

    return {
      "total":dataValeursTableau.length,
      "collecte":list.length,
      "taux":ratio
    };
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if (tableauBordController.statusIntialisation.value == false){
        return Container();
      }
      final json = getInfosTableau(tableauBordController.dataIndicateur.value.valeurs, tableauBordController.currentMonth.value);
      final ratio = json["taux"];
      return  Row(
        children: [
          //Text("${tableauBordController.currentMonth.value}"),
          Row(
            children: [
              const CustomText(
                text: "Le progrès de collecte est égale à ",
                size: 15,
              ),
              CustomText(
                text: ratio !=null? "${ratio.toStringAsFixed(2)} %" :"--- %",
                size: 15,
                color: ratio < 25 ? Colors.red : ratio < 50 ? Colors.amber : ratio < 75 ? Colors.green : Colors.blue,
                weight: FontWeight.bold,
              ),
              CustomText(
                text: " (${json["collecte"]} indicateur${json["collecte"]>1?"s":""} renseigné${json["collecte"]>1?"s":""}/ ${json["total"]})",
                size: 15,
                weight: FontWeight.bold,
              ),
              const CustomText(
                text: " ce mois-ci. ",
                size: 15,
              ),
            ],
          ),
          const SizedBox(width: 20,),
          if(ratio !=null ) ProgressBar(progressValue: ratio),
          const SizedBox(width: 5,),
        ],
      );
    });
  }
}
