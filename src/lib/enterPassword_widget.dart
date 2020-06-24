import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';

import 'main_widget.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage();
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<SettingDTO> settings;
  SettingDTO setting = SettingDTO();
  String checkPassword;

  Future<void> submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    await DBController().insertSettings(setting);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Main()),
    );
  }

  Future<void> fetchSettings() async {
    var fetchedSetting = await DBController().settings();
    setState(() {
      settings = fetchedSetting;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (settings == null) {
      return Center(
        child: buildEasyFinanceLogo(),
      );
    }
    if (settings.isEmpty) {
      return buildSetPassword();
    }
    return buildEnterPassword();
  }

  Widget buildScaffold(List<Widget> body) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: body)));
  }

  Widget buildEasyFinanceLogo() {
    return Image(
      image: AssetImage('lib/assets/easyFinance_200x200.png'),
    );
  }

  Widget buildEnterPassword() {
    return buildScaffold(<Widget>[
      SizedBox(
        height: 50,
      ),
      buildEasyFinanceLogo(),
      SizedBox(
        height: 50,
      ),
      Text(
        'Welcome back ${settings[0].username}',
        style: TextStyle(
          color: Colors.green[500],
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 50,
      ),
      buildCard(Form(
              key: _formKey,
              child: Column(children: <Widget>[
                buildPasswordField(),
                buildSubmitButton()
              ])))
    ]);
  }

  Widget buildSetPassword() {
    return buildScaffold(
      <Widget>[
        SizedBox(
          height: 50,
        ),
        buildEasyFinanceLogo(),
        SizedBox(
          height: 50,
        ),
        Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),  
        child:Text(
          'Please set a username and password before you start',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.green[500]),
        )),
        Divider(
          height: 30,
        ),
        buildCard(Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildUsernameField(),
              buildSetPasswordField(),
              buildCheckPasswordField(),
              buildSubmitButton()
            ],
          ),
        ))
      ],
    );
  }

  Widget buildCard(Widget child) {
    return Card(
        elevation: 4.0, // shadow
        margin: EdgeInsets.fromLTRB(10, 10, 10, 100),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: child,
        ));
  }

  RaisedButton buildSubmitButton() {
    return RaisedButton(
      child: Text('Log In'),
      onPressed: submit,
    );
  }

  TextFormField buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'username'),
      onChanged: (String value) {
        setState(() {
          setting.username = value;
        });
      },
      validator: (String value) {
        if (value.length < 1) {
          return 'username is required';
        }
        return null;
      },
    );
  }

  TextFormField buildCheckPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'repeat password'),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          checkPassword = value;
        });
      },
      validator: (String value) {
        if (value == null || value != setting.password) {
          return 'Passwords doesn\'t match';
        }
        return null;
      },
    );
  }

  TextFormField buildSetPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'password'),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          setting.password = value;
        });
      },
      validator: (String value) {
        if (value.length < 8) {
          return 'Password is too short';
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'password'),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          setting.password = value;
        });
      },
      validator: (String value) {
        if (settings[0].password != value) {
          return 'Wrong password';
        }
        return null;
      },
    );
  }
}
