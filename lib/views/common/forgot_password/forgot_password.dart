import 'package:flutter/material.dart';
import 'widgets/send_token_form.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPassword> {
  var onHoverLogin = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color(0xFFF4F4F4),
        child: Column(
          children: [
            Expanded(
                child: Row(
                  children: [
                    if(width > 1100) Expanded(child: Container(
                      height: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFBCD18),
                              Color(0xFFFABC29),
                              Color(0xFFFBCD18),
                              Color(0xFFFBCD18),
                            ],
                          )
                      ),
                      child: Image.asset("assets/images/password_change.png",fit: BoxFit.contain,width: width,),
                    )),
                    Expanded(child: Center(child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: const SendTokenToEmailForm(),),
                    ))
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
