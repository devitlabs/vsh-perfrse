import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:perf_rse/models/pilotage/indicateur_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IndicateursScreen extends StatefulWidget {
  const IndicateursScreen({super.key});

  @override
  State<IndicateursScreen> createState() => _IndicateursScreenState();
}

class _IndicateursScreenState extends State<IndicateursScreen> {

  late IndicateurDataGridSource indicateurDataGridSource;

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  bool edition = false;


  Future<List<IndicateurModel>> getListIndicateurs() async{
    setState(() {
      isLoading = true;
    });
    final List responseIndicateurs = await supabase.from("Indicateurs").select().order('numero', ascending: true);
    final listIndicateur = responseIndicateurs.map((json) => IndicateurModel.fromJson(json)).toList();
    setState(() {
      isLoading = false;
    });
    return listIndicateur;
  }


  void refreshData() async {
    final response = await getListIndicateurs();
    setState(() {
      indicateurDataGridSource = IndicateurDataGridSource(indicateurs: response,edition: edition);
    });
  }

  late bool isWebOrDesktop;


  @override
  void initState() {
    super.initState();
    refreshData();
  }

  SfDataGridTheme  _buildDataGridForWeb() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: Brightness.light,
          rowHoverColor: Colors.white,
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: Colors.blue),
      child: SfDataGrid(
        source: indicateurDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        frozenColumnsCount: 3,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        columns: <GridColumn>[
          GridColumn(
              width: 70,
              columnName: 'numero',
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Numéro',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
          GridColumn(
            columnName: 'reference',
            width: 100,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Référence',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'intitule',
            width: 400.0,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Intitulé',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'definition',
            width: 450.0,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Définition',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
              columnName: 'unite',
              width: 100,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Unité',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
          GridColumn(
              columnName: 'type',
              width: 100,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Type',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
          GridColumn(
            columnName: 'formule',
            width: 100,
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Formule',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          GridColumn(
            columnName: 'processus',
            width: 150,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Processus',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'odd',
            width: 70,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'odd',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'gri',
            width: 70,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'gri',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionWidget() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onHover: (value){},
          onTap: () async {
            refreshData();
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Icon(Icons.refresh_sharp,size: 25,color: Colors.green),
                SizedBox(width: 5,),
                Text("Rafraîchir")
              ],
            ),
          ),
        ),
        SizedBox(width: 10,),
        Text("Edition"),
        SizedBox(width: 5,),
        Switch(value: edition, onChanged: (value){
          setState(() {
            edition = value;
          });
          refreshData();
        },activeColor: Colors.blue,),
        Expanded(child: Container()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: isLoading ? loadingPageWidget() : Column(
        children: [
          Container(height: 40,child: actionWidget(),),
          const SizedBox(height: 5,),
          Expanded(child: _buildDataGridForWeb())
        ],
      ),
    );
  }
}


class IndicateurDataGridSource extends DataGridSource {
  
  

  IndicateurDataGridSource({required List<IndicateurModel> indicateurs,required bool edition }) {
    _indicateurs = indicateurs;
    _edition = edition;
    buildDataGridRow();
  }
  
  List<IndicateurModel> _indicateurs = <IndicateurModel>[];
  bool _edition = false;
  final supabase = Supabase.instance.client;

  List<DataGridRow> dataGridRows = <DataGridRow>[];


  void buildDataGridRow() {
    dataGridRows = _indicateurs.map<DataGridRow>((IndicateurModel indicateur) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<Map<String,dynamic>>(columnName: 'numero', value: {"valeur":indicateur.numero,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'reference', value: {"valeur":indicateur.reference,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'intitule', value: {"valeur":indicateur.intitule,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'definition', value: {"valeur":indicateur.definition,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'unite', value: {"valeur":indicateur.unite,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'type', value: {"valeur":indicateur.type,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'formule', value: {"valeur":indicateur.formule,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'processus', value: {"valeur":indicateur.processus,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'odd', value: {"valeur":indicateur.odd,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
        DataGridCell<Map<String,dynamic>>(columnName: 'gri', value: {"valeur":indicateur.gri,"type":indicateur.type,"numero":indicateur.numero,"reference":indicateur.reference}),
      ]);
    }).toList();
  }


  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
          switch (dataCell.columnName) {
            case "intitule":
              return Container(
                color: dataCell.value["type"] == "Calculé" ? const Color(0xFFFDDDCC) : dataCell.value["type"] == "Test" ? const Color(0xFFB3B9C0) : Colors.transparent,
                padding: const EdgeInsets.only(left: 8.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Flexible(child: Text("${dataCell.value["valeur"]??"---"}",maxLines: 2,overflow: TextOverflow.ellipsis,)),
                    if (_edition) EditIndicateur(reference: dataCell.value["reference"], champ: "intitule", valeur: '${dataCell.value["valeur"]??""}',)
                  ],
                ),
              );
            case "definition":
              return Container(
                color: dataCell.value["type"] == "Calculé" ? const Color(0xFFFDDDCC) : dataCell.value["type"] == "Test" ? const Color(0xFFB3B9C0) : Colors.transparent,
                padding: const EdgeInsets.only(left: 8.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Flexible(child: Text("${dataCell.value["valeur"]??"---"}",maxLines: 2,overflow: TextOverflow.ellipsis,)),
                    if (_edition) EditIndicateur(reference: dataCell.value["reference"], champ: "definition", valeur: '${dataCell.value["valeur"]??""}',)
                  ],
                ),
              );
            default :
              return Container(
                color: dataCell.value["type"] == "Calculé" ? const Color(0xFFFDDDCC) : dataCell.value["type"] == "Test" ? const Color(0xFFB3B9C0) : Colors.transparent,
                padding: const EdgeInsets.only(left: 8.0),
                alignment: Alignment.centerLeft,
                child: Text("${dataCell.value["valeur"]??"---"}",maxLines: 2,overflow: TextOverflow.ellipsis,),
              );
          }
        }).toList()
    );
  }

}


class EditIndicateur extends StatefulWidget {
  final String reference;
  final String champ;
  final String valeur;
  const EditIndicateur({super.key, required this.reference, required this.champ, required this.valeur});

  @override
  State<EditIndicateur> createState() => _EditIndicateurState();
}

class _EditIndicateurState extends State<EditIndicateur> {

  final TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    valueController.text = widget.valeur;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5,),
        IconButton(onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Indicateur ${widget.reference} -- Champ : ${widget.champ == "initule" ? "Initulé" : "Définition"}",style: TextStyle(color:Colors.red),),
                contentPadding: const EdgeInsets.all(30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                titlePadding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                content: Container(width: 400,height: 200,child: Column(
                  children: [
                    TextFormField(
                      controller: valueController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text('Annuler'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await Supabase.instance.client.from('Indicateurs').update({'${widget.champ}': valueController.text}).eq('reference',widget.reference);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Valider')
                        )
                      ],
                    )

                  ],
                ),),
              );
            },);
        },splashRadius: 15, icon: Icon(Icons.edit,size: 20,color: Colors.green,))
      ],
    );
  }
}


