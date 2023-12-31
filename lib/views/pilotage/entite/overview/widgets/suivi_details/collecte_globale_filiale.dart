import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../api/supabse_db.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../controllers/entite_pilotage_controler.dart';

class CollecteGlobaleEntites extends StatefulWidget {
  const CollecteGlobaleEntites({
    Key? key,
  }) : super(key: key);

  @override
  State<CollecteGlobaleEntites> createState() => _CollecteGlobaleEntitesState();
}

class _CollecteGlobaleEntitesState extends State<CollecteGlobaleEntites> {

  List<Map<String,dynamic>> entityInfos  = [];
  final DataBaseController apiClient = DataBaseController();
  int status = 0;
  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();
  final year = DateTime.now().year;

  void initialisation() async {
    List<Map<String,dynamic>> kEntityInfos  = [];
    try {
      final entiteID = entitePilotageController.currentEntite.value;
      final List suiviDocList = await supabase.from('SuiviData').select().gte("annee", year-1);
      final List entiteList = await supabase.from('Entites').select().eq("id_entite", entiteID);
      final List affichageEnites = entiteList.first["filtre_entite_id"];
      for (var kEniteId in affichageEnites ) {
        Map<String,dynamic> doc = {
          "${year}":0,"${year-1}":0
        };
        final ligneAnneeN = suiviDocList.firstWhere((element) => (element["annee"] == year && element["id_entite"] == kEniteId ) );
        doc["nom"] = ligneAnneeN["nom_entite"];
        num percentage = (ligneAnneeN["indicateur_collectes"] / ligneAnneeN["indicateur_total"]) ;
        doc["${year}"] = num.parse(percentage.toStringAsFixed(2));

        try {
          final ligneAnneeN1 = suiviDocList.firstWhere((element) => (element["annee"] == year-1 && element["id_entite"] == kEniteId ));
          if (ligneAnneeN1 != null ) {
            doc["${year-1}"] = ligneAnneeN1["indicateur_collectes"] / ligneAnneeN1["indicateur_total"];
          }
        } catch (e) {
          doc["${year-1}"] = 0;
          apiClient.updateSuiviDataEntite(kEniteId, year-1);
        }

        kEntityInfos.add(doc);
      }
    } catch (e) {
      setState(() {
        status = -1;
      });
    }
    setState(() {
      status = 1;
      entityInfos = kEntityInfos;
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child:  entityInfos.isEmpty ? Container(
          width: double.infinity,
          height: 300,
          child: Center(
            child: Container(
              width: 50,height: 50,
              child: status == -1 ? Text("Aucune donnée") : CircularProgressIndicator(),),
          ),
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
                columnSpacing: 12,
                horizontalMargin: 12,
                columns:  [
                  DataColumn(
                    label: Text("Filiale/Entités"),
                  ),
                  DataColumn(
                    label: Text("${year-1}"),
                  ),
                  DataColumn(
                    label: Text("${year}"),
                  ),
                ],
                rows: List.generate(
                  entityInfos.length,
                      (index) => dataRow(entityInfos[index]),
                )
            )
          ],
        ),
      ),
    );
  }

  DataRow dataRow(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text("${entityInfo["2022"]} %",style: TextStyle(fontWeight: FontWeight.bold,color: entityInfo["2022"] < 30 ?  Colors.red :
        entityInfo["${year-1}"] < 60 ? Colors.yellow : entityInfo["${year-1}"] < 75 ?
        Colors.green : Colors.blue),)),
        DataCell(Text("${entityInfo["2023"]} %",style: TextStyle(fontWeight: FontWeight.bold,color: entityInfo["2023"] < 30 ?  Colors.red :
        entityInfo["${year}"] < 60 ? Colors.yellow : entityInfo["${year}"] < 75 ?
        Colors.green : Colors.blue),))
      ],
    );
  }
}