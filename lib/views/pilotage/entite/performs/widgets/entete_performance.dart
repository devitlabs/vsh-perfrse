import 'package:flutter/material.dart';

import '../../../../../constants/constant_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/menu_deroulant.dart';
import '../../../../../widgets/unimpleted_widget.dart';

class EntetePerformance extends StatefulWidget {
  const EntetePerformance({Key? key}) : super(key: key);

  @override
  State<EntetePerformance> createState() => _EntityWidgetWidgetState();
}

class _EntityWidgetWidgetState extends State<EntetePerformance> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomText(text: "Filtre",size: 20,),
        const SizedBox(width: 5,),
        Container(height: 40,width: 1,color: Colors.grey,),
        const SizedBox(width: 20,),
        const CustomText(text: "Année",size: 20,),
        const SizedBox(width: 5,),
        MenuDeroulant(
          indication: "",
          initValue: "2023",
          items: const ["2022","2023"],
          width: 100,
          onChanged: (value){
          },
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () async {},
              splashRadius: 20,
              icon: const Icon(Icons.refresh_sharp,color: Color(0xFF4F80B5),)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {
                UnimplementedWidget.showDialog();
              },
              icon: const Icon(Icons.print,color: Colors.white,),
              label: const CustomText(
                text: "Imprimer",
                color: light,
                size: 15,
              )),
        ),
      ],
    );
  }
}