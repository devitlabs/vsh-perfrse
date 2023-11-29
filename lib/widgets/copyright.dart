import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CopyRight extends StatefulWidget {
  const CopyRight({Key? key}) : super(key: key);

  @override
  State<CopyRight> createState() => _CopyRightState();
}

class _CopyRightState extends State<CopyRight> {

  bool isConnected = true ;
  final supabase = Supabase.instance.client;

  String version = "";

  Future getVersionApp() async {
    final reponse = await supabase.from("System").select().eq("id", 0);
    setState(() {
      version = reponse[0]["app_version"];
    });
  }

  @override
  void initState() {
    getVersionApp();
    super.initState();
    //getInternetStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF6E4906),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: InkWell(
              onTap: () async {
                const url = "https://visionstrategie.com/";
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
                else {
                  throw "Could not launch $url";
                }
              },
              child: CustomText(
                  text: "Copyright @ Vision & Strategie Groupe ${version}",
                 size: 15,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: RichText(
              text: TextSpan(
                text: "Statut : ",
                children: [
                  TextSpan(
                      text: isConnected ? "Connecté" : "Aucune connection internet" ,
                      style: TextStyle(color: isConnected ? Colors.green: Colors.red))
                ],
                style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void  getInternetStatus() async {
    while (true) {
      try {
        var response = await http.get(Uri.parse('http://127.0.0.1:5000/'),headers: {
          "Access-Control-Allow-Origin":"*"
        });
        if (response.statusCode == 200) {
          setState(() {
            isConnected = true;
          });
        }
      } catch (e){
        setState(() {
          isConnected = false;
        });
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}
