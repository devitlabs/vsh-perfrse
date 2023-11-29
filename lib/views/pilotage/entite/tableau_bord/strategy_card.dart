import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/custom_text.dart';
import '../../controllers/entite_pilotage_controler.dart';


class StrategieContainer extends StatefulWidget {
  const StrategieContainer({super.key});

  @override
  State<StrategieContainer> createState() => _StrategieContainerState();
}
class _StrategieContainerState extends State<StrategieContainer> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      width: 900,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: 400,height: 200,
                child: Padding(padding: EdgeInsets.all(8.0), child: StrategyButton(
                  color: Color(0xFFFAAF7B),
                  imagePilier: "assets/icons/social.png",
                  titlePilier: "Communauté et innovation sociétale",
                  enjeux: [
                    {"key":"7","enjeu":"Inclusion sociale ét dévéloppementdes communautés"},
                  ],
                ),
                ),
              )
          ),
          Positioned(
              left: 500,
              bottom: 300,
              child: SizedBox(
                width: 400,height: 200,
                child: Padding(padding: EdgeInsets.all(8.0), child: StrategyButton(
                  color: Color(0xFF3F93D0),
                  imagePilier: "assets/icons/gouvernance.png",
                  titlePilier: "Gouvernance éthique",
                  enjeux: [
                    {"key":"1a","enjeu":"Gouvernance DD et stratégie"},
                    {"key":"1b","enjeu":"Pilotage DD"},
                    {"key":"2","enjeu":"Éthique des affaires et achats responsables"},
                    {"key":"3","enjeu":"Intégration des attentes DD des clients et consommateurs"},
                  ],
                ),),
              )
          ),
          Positioned(
              left: 500,
              bottom: 0,
              child: SizedBox(
                width: 400,height: 200,
                child: Padding(padding: EdgeInsets.all(8.0), child: StrategyButton(
                  color: Color(0xFFEABF64),
                  imagePilier: "assets/icons/economie.png",
                  titlePilier: "Emploi et conditions de travail",
                  enjeux: [
                    {"key":"4","enjeu":"Égalité de traitement"},
                    {"key":"5","enjeu":"Conditions de travail"},
                    {"key":"10","enjeu":"Amélioration du cadre de vie"},
                  ],
                ),),
              )
          ),
          Positioned(
              left: 0,
              bottom: 300,
              child: SizedBox(
                width: 400,height: 200,
                child: Padding(padding: EdgeInsets.all(8.0), child: StrategyButton(
                  color: Color(0xFF97C3A8),
                  imagePilier: "assets/icons/environnement.png",
                  titlePilier: "Environnement",
                  enjeux: [
                    {"key":"8","enjeu":"Changement climatique et déforestation"},
                    {"key":"9","enjeu":"Gestion et traitement de l’eau"},
                    {"key":"10","enjeu":"Gestion des ressources et déchets"},
                  ],
                ),),
              )
          ),
          Positioned(
              left: 375,
              bottom: 175,
              child: GeneralButton()
          ),
        ],
      ),
    );
  }
}

class StrategyButton extends StatefulWidget {
  final String titlePilier;
  final String imagePilier;
  final List<Map> enjeux;
  final Color color;
  const StrategyButton({super.key, required this.titlePilier, required this.imagePilier, required this.enjeux, required this.color});

  @override
  State<StrategyButton> createState() => _StrategyButtonState();
}
class _StrategyButtonState extends State<StrategyButton> {
  final EntitePilotageController entitePilotageController = Get.find();
  double elevation = 5;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          context.go("/pilotage/espace/${entitePilotageController.currentEntite.value}/tableau-de-bord/indicateurs");
        },
        onHover: (value){
            if (value) {
              setState(() {
                elevation = 20;
              });
            }else {
              setState(() {
                elevation = 5;
              });

            }
        },
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: widget.color,
        ),
        child: SizedBox(
          width: 400,
          height: 200,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("${widget.imagePilier}",width: 40,height: 40,),
                    const SizedBox(width: 10,),
                    Flexible(child: Text("${widget.titlePilier}",style: const TextStyle(color: Colors.black,fontSize: 18),))
                  ],
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Column(
                    children: widget.enjeux.map((enjeu){
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle
                                ),
                                child: Center(child: Text("${enjeu["key"]}")),
                              ),
                              const SizedBox(width: 5,),
                              Flexible(child: CustomText(text: "${enjeu["enjeu"]}",size: 13,fontStyle: FontStyle.italic,))
                            ],
                          ),
                          const SizedBox(height: 5,),
                        ],
                      );
                    }).toList()
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}


class GeneralButton extends StatefulWidget {
  const GeneralButton({super.key});

  @override
  State<GeneralButton> createState() => _GeneralButtonState();
}
class _GeneralButtonState extends State<GeneralButton> {
  final EntitePilotageController entitePilotageController = Get.find();
  double elevation = 5;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        context.go("/pilotage/espace/${entitePilotageController.currentEntite.value}/tableau-de-bord/indicateurs");
      },
      onHover: (value){
        if (value) {
          setState(() {
            elevation = 20;
          });
        }else {
          setState(() {
            elevation = 5;
          });

        }
      },
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          elevation: elevation,
          backgroundColor: Colors.brown,
          padding: EdgeInsets.zero
      ),
      child: Container(
        width: 150,height: 150,
        child: Container(
          width: 50,
          height: 50,
          color: Colors.transparent,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: "Afficher",color: Colors.white,size: 18,),
              CustomText(text: "Tous",color: Colors.white,size: 18,),
              CustomText(text: "Les indicateurs",color: Colors.white,size: 18,)
            ],
          ),
        )
      ),
    );
  }
}

