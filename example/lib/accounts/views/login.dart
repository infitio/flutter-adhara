import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/i.dart';
import 'package:flutter/gestures.dart';


class LoginPage extends AdharaStatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends AdharaState<LoginPage> {

  String get tag => "LoginPage";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User();
  String buttonText = "login";
  String invalidCredentials = "";

  void submit(context) async {
    setState((){
      buttonText = "logging_in";
    });
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
//      try {
//        User _user = await (r.dataInterface as AppDataInterface).login(user);
//        trigger(Events.LOGGED_IN, _user); //Trigger captured in ideaspace_app.dart will update to splash screen again...
//      }catch(response){
//        buttonText = "login";
//        invalidCredentials = {
//          400: "invalid_credentials"
//        }[response.statusCode] ??
//            AppUtils.getErrorMessageFromResponse(context, response);
//        setState((){});
//        /*Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text(r.getString(invalidCredentials))
//        ));*/
//      }
    } else {
      setState((){ buttonText = "login"; invalidCredentials = ""; });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts login page!"),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Form(
              key: this._formKey,
              child: Builder(
                  builder: (BuildContext context) {
                    return _buildMainColumn(context);
                  }
              )
          )
      ),
    );
  }

  _buildMainColumn(BuildContext context){

    final username = TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: ar.getString("login_key"),
        ),
        validator: (String value) {
          if (value.length == 0) {
            return ar.getString("login_key_error");
          }
          return null;
        },
        onSaved: (String value) {
          user.userName = value;
        }
    );

    final password = TextFormField(
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
            hintText: r.getString("password"),
        ),
        validator: (String value) {
          if (value.length < 1) {
            return r.getString("password_error");
          }
          return null;
        },
        onSaved: (String value) {
          user.password = value;
        }
    );

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(36.0, 8.0, 36.0, 5.0),
            child: username,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(36.0, 5.0, 36.0, 5.0),
            child: password,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(36.0, 5.0, 36.0, 60.0),
            child: Text(
              r.getString(invalidCredentials),
              style: TextStyle(color: Colors.red),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12.0, 5.0, 36.0, 15.0),
            child: Center(
              child: RichText(
                  text: new TextSpan(text: "Don't have an account?", children: [
                    new TextSpan(
                      text: ' Signup now!',
                      recognizer: new TapGestureRecognizer()..onTap = () => Navigator.of(context).pushNamed('/accounts/signup'),
                      style: TextStyle(color: Colors.lightBlueAccent)
                    )
                  ], style: TextStyle(color: Colors.black))
              ),
            ),
          ),
          BottomButton( r.getString(buttonText),
              onPressed: () => this.submit(context) )
        ]
    );
  }

}