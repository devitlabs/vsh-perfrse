import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/export_widget.dart';
import '../../../widgets/loading_widget.dart';
import 'widget/banniere.dart';
import 'widget/custom_cadre.dart';
import 'widget/header_main_page.dart';
import '../../../modules/styled_scrollview.dart';


class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  late Future<Map> mainData;

  @override
  void initState() {
    super.initState();
    mainData = loadDataMain();
  }

  Future<Map> loadDataMain () async{
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email);
    data["user"] = user[0] ;
    return data;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Vous n'avez pas accès à cet espace."),
                const SizedBox(height: 20,),
                Image.asset("assets/images/forbidden.png",width: 50,height: 50,)
              ],
            ),
          ),
        );
      },
    );
  }


  Future<bool> checkAccesPilotage(String email) async {
    final result = await supabase.from("AccesPilotage").select().eq("email", email);
    final acces = result[0];
    if (acces["est_bloque"]) {
      _showMyDialog();
      return false;
    }
    if (acces["est_admin"]) {
      context.go("/pilotage");
      return true;
    }
    if (acces["est_spectateur"] || acces["est_editeur"] || acces["est_validateur"] || acces["est_admin"]) {
      context.go("/pilotage");
      return true;
    }
    _showMyDialog();
    return false;
  }

  Future<bool> checkAccesEvaluation(String email) async {
    context.go("/evaluation");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: mainData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingWidget(),
            ),
          );
        }
        final data = snapshot.data!;
        return Scaffold(
          body: Column(
            children: [
              HeaderMainPage(title: "Général",mainPageData: data,),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/background_image.jpg"),
                          fit: BoxFit.fitWidth)),
                  child: StyledScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                        text: "Bienvenue dans ",
                                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  Image.asset(
                                    "assets/logos/perf_rse.png",
                                    height: 50,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Center(child: Banniere()),
                              const SizedBox(
                                height: 10,
                              ),
                              //Text("${MediaQuery.of(context).size.height} x ${MediaQuery.of(context).size.width}"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCadre(
                                    onTap: () async {
                                      checkAccesEvaluation("${data["user"]["email"]}");
                                    },
                                    imagePath: "assets/images/audit_rse.png",
                                    titreCadre: "Evaluation",
                                  ),
                                  CustomCadre(
                                    onTap: (){
                                      checkAccesPilotage("${data["user"]["email"]}");
                                    },
                                    imagePath: "assets/images/pilotage_rse.jpg",
                                    titreCadre: "Pilotage",
                                  ),
                                  CustomCadre(
                                    onTap: () {
                                      _showMyDialog();
                                    },
                                    imagePath: "assets/images/reporting_rse.jpg",
                                    titreCadre: "Reporting",
                                  ),
                                ],
                              )
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                tooltip: "Se déconnecter",
                                alignment: Alignment.center,
                                padding: EdgeInsets.zero,
                                style: IconButton.styleFrom(
                                    iconSize: 50
                                ),
                                icon: const Icon(
                                  Icons.exit_to_app_outlined,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Voulez-vous quitter l'application ?"),
                                        content: const SizedBox(width:200,child: Text('Cliquez sur Oui pour vous déconnecter.')),
                                        actionsAlignment: MainAxisAlignment.spaceBetween,
                                        actions: <Widget>[
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Non'),
                                          ),
                                          OutlinedButton(
                                            onPressed: () async {
                                              await storage.write(key: 'logged', value: "");
                                              await storage.write(key: 'email', value: "");
                                              await storage.deleteAll();
                                              await supabase.auth.signOut();
                                              context.go('/account/login');
                                            },
                                            child: const Text('Oui'),
                                          ),
                                        ],
                                      );
                                    },);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const CopyRight()
            ],
          ),
        );
      },
    );
  }
}
