import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parcial_app/helpers/constans.dart';
import 'package:parcial_app/models/result.dart';
import 'package:parcial_app/models/token.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _Like = '';
  String _LikeError = '';
  bool _LikeShowError = false;
  TextEditingController _LikeController = TextEditingController();

  String _DontLike = '';
  String _DontLikeError = '';
  bool _DontLikeShowError = false;
  TextEditingController _DontLikeController = TextEditingController();

  String _OtherComents = '';
  String _OtherComentsError = '';
  bool _OtherComentsShowError = false;
  TextEditingController _OtherComentsController = TextEditingController();

  String _Note = '3';
  String _NoteError = '';
  bool _NoteShowError = false;
  bool _consultadoInicial = false;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      if (!_consultadoInicial) {
        _GetData();
      }
    });
    return Scaffold(
       backgroundColor: Color(0xFFE0F2F1),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _initialimage(),
               SizedBox(height: 20,),
              _showEmail(),
              _showLike(),
              _showDontLike(),
              _showOtherComents(),
              _showNote(),
              _showutton()
            ],
          ),
        ),
      ],
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa tu email',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          prefixIcon: Icon(Icons.alternate_email),
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showNote() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Color(0XFFF9A825),
      ),
      onRatingUpdate: (rating) {
        _Note = rating.toString();
      },
    );
  }

  Widget _showLike() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _LikeController,
        decoration: InputDecoration(
          fillColor: Colors.white,
           filled: true,
          hintText: 'Que cosas te gustaron del curso?',
          labelText: 'Lo Bueno',
          errorText: _LikeShowError ? _LikeError : null,
          suffixIcon: Icon(Icons.check),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _Like = value;
        },
      ),
    );
  }

  Widget _showDontLike() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _DontLikeController,
        decoration: InputDecoration(
          fillColor: Colors.white,
           filled: true,
          hintText: 'Cuales cosas no te gustaron?',
          labelText: 'Cosas Malas de curso',
          errorText: _DontLikeShowError ? _DontLikeError : null,
          suffixIcon: Icon(Icons.not_interested),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _DontLike = value;
        },
      ),
    );
  }

  Widget _showOtherComents() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _OtherComentsController,
        decoration: InputDecoration(
          fillColor: Colors.white,
           filled: true,
          hintText: 'Algo mas para comentar?',
          labelText: 'Algo mas para decir?',
          errorText: _OtherComentsShowError ? _OtherComentsError : null,
          suffixIcon: Icon(Icons.other_houses),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _OtherComents = value;
        },
      ),
    );
  }

  Widget _showutton() {
    return ElevatedButton(
      child: Text('Guardar'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Color(0xDD000000);
        }),
      ),
      onPressed: () => _guardar(),
    );
  }

  void _guardar() {
    if (_validate()) {
      _guardarResultados();
    }
  }

  bool _validate() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'ingresa una cuenta de correo valida';
    } else if (!EmailValidator.validate(_email) &&
        !_email.contains(".itm.edu.co")) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'ingresa una cuenta de correo valida';
    } else {
      _emailShowError = false;
    }
    if (_Like.isEmpty) {
      isValid = false;
      _LikeShowError = true;
      _LikeError = 'Que te gustò mas del surso?';
    } else {
      _LikeShowError = false;
    }
    if (_DontLike.isEmpty) {
      isValid = false;
      _DontLikeShowError = true;
      _DontLikeError = 'que fue lo malo del curso?';
    } else {
      _DontLikeShowError = false;
    }
    if (_OtherComents.isEmpty) {
      isValid = false;
      _OtherComentsShowError = true;
      _OtherComentsError = 'Tienes alguna sugerencia o comentario?';
    } else {
      _OtherComentsShowError = false;
    }

    setState(() {});
    return isValid;
  }

  void _guardarResultados() async {
    ResultFields resultFields = ResultFields(
        id: 1,
        date: DateTime.now().toString(),
        email: _email,
        qualification: int.parse(_Note.substring(0, 1)),
        theBest: _Like,
        theWorst: _DontLike,
        remarks: _OtherComents);
    var url = Uri.parse('${Constans.apiUrl}/Finals');
    String strResultFields = jsonEncode(resultFields);
    http.Response response = await http.post(url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': 'bearer ${widget.token.token}',
        },
        body: strResultFields);

    String body = response.body;
    if (response.statusCode >= 400) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ocurrio un error al guardar.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } else {
      await showAlertDialog(
          context: context,
          title: 'Guardado',
          message: 'Informacion guardada',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

  void _GetData() async {
    var url = Uri.parse('${Constans.apiUrl}/Finals');
    http.Response response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
    );
    String body = response.body;
    var decodedJson = jsonDecode(body);
    ResultFields resultFields = ResultFields.fromJson(decodedJson);
    _emailController.text = resultFields.email;
    _email = resultFields.email;
    _LikeController.text = resultFields.theBest;
    _Like = resultFields.theBest;
    _DontLikeController.text = resultFields.theWorst;
    _DontLike = resultFields.theWorst;
    _OtherComentsController.text = resultFields.theWorst;
    _OtherComents = resultFields.theWorst;
    setState(() {});
    _consultadoInicial = true;
  }

 Widget _initialimage() {
     return Image(
       image: AssetImage('assets/pensamiento.jpg'),
       width: 170,
       );

  }
}