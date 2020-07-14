import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/i.dart';

class SignupPage extends AdharaStatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();

}

class _SignupPageState extends AdharaState<SignupPage> {

  String get tag => "SignupPage";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User();
  String buttonText = "signup";
  String invalidCredentials = "";

  void submit(context) async {
    setState((){
      buttonText = "logging_in";
    });
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
//      try {
//        User _user = await (r.dataInterface as AppDataInterface).signup(user);
//        trigger(Events.LOGGED_IN, _user); //Trigger captured in ideaspace_app.dart will update to splash screen again...
//      }catch(response){
//        buttonText = "signup";
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
      setState((){ buttonText = "signup"; invalidCredentials = ""; });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts signup page!"),
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
          hintText: ar.getString("signup_key"),
        ),
        validator: (String value) {
          if (value.length == 0) {
            return ar.getString("signup_key_error");
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

    final confirmPassword = TextFormField(
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
            margin: EdgeInsets.fromLTRB(36.0, 5.0, 36.0, 5.0),
            child: confirmPassword,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(36.0, 5.0, 36.0, 60.0),
            child: Text(
              r.getString(invalidCredentials),
              style: TextStyle(color: Colors.red),
            ),
          ),
          BottomButton( r.getString(buttonText),
              onPressed: () => this.submit(context) )
        ]
    );
  }

}