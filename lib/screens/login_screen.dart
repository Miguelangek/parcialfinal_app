import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:parcial_app/helpers/constans.dart';
import 'package:parcial_app/models/token.dart';
import 'package:parcial_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F2F1),
       body:  Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children:<Widget>[
             _showLogo(),
             _showGoogleLogin()

           ],
         )
         ),
    );
  }

  Widget _showLogo() {
     return Image(
       image: AssetImage('assets/encuesta.png'),
       width: 500,
       );

  }
Widget _showGoogleLogin() {
   return Row(children:<Widget> [
       Expanded
       (child: ElevatedButton.icon(
         onPressed: () => _loginGoogle() , 
         icon: FaIcon(
           FontAwesomeIcons.google,
           color: Colors.red,
         ), 
         label: Text('Iniciar Sesion con Google'),
         style: ElevatedButton.styleFrom(
           primary: Colors.black,
           onPrimary: Colors.white
         ),
         )
       
       )

   ],
   );

}

 

 //desde aca copie

void _loginGoogle() async {
    var googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    var user = await googleSignIn.signIn();

    if (user == null) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Hubo un problema al obtener el usuario de Google, por favor intenta más tarde.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'email': user.email,
      'id': user.id,
      'loginType': 1,
      'fullName': user.displayName,
      'photoURL': user.photoUrl,
    };
    await _socialLogin(request);
  }

  Future _socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse('${Constans.apiUrl}/Account/SocialLogin');
    var bodyRequest = jsonEncode(request);
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: bodyRequest,
    );

    if (response.statusCode >= 400) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'El usuario ya inció sesión previamente por email o por otra red social.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var body = response.body;

    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  token: token,
                )));
  }




}