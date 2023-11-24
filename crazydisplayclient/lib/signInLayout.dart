import 'package:crazydisplayclient/main.dart';
import 'package:flutter/material.dart';
import 'package:crazydisplayclient/appData.dart';
import 'package:provider/provider.dart';

class SignInPage1 extends StatefulWidget {
  const SignInPage1({Key? key}) : super(key: key);

  @override
  State<SignInPage1> createState() => _SignInPage1State();
}

class _SignInPage1State extends State<SignInPage1> {
  final TextEditingController _idController =
      TextEditingController(text: "192.168.0.25");
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Morioh.png',
                        width: 128.0, height: 128.0),
                    _gap(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Crazy Diamond Display",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Enter IP, username and password to continue.",
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        // add username validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        return null;
                      },
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'IP',
                        labelStyle: TextStyle(
                          color:
                              appData.colorSec, // Set your desired color here
                        ),
                        hintText: 'Connect to IP',
                        prefixIcon: Icon(Icons.wifi, color: appData.colorSec),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appData.colorSec,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        // add username validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        return null;
                      },
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color:
                              appData.colorSec, // Set your desired color here
                        ),
                        hintText: 'Enter your username',
                        prefixIcon: Icon(Icons.person_2_outlined,
                            color: appData.colorSec),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appData.colorSec,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color:
                                appData.colorSec, // Set your desired color here
                          ),
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline_rounded,
                              color: appData.colorSec),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appData.colorSec,
                              width: 2.0,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: appData.colorSec,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )),
                    ),
                    _gap(),
                    CheckboxListTile(
                      value: _rememberMe,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                      title: const Text('Remember me'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          backgroundColor: appData.colorSec,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 5.0,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          if (await appData.connectToServer(
                              _usernameController.text,
                              _passwordController.text)) {
                            setState(() {
                              appData.isLoggedIn = true;
                              appData.userName = appData.isLoggedIn
                                  ? _usernameController.text
                                  : 'Not logged in';
                              appData.showLoginForm = false;
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Login Successful'),
                                      content: Text(
                                          'Welcome in ${_usernameController.text}.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                appData.showLoginForm = false;
                                                if (appData.connect) {
                                                  Provider.of<AppData>(context,
                                                          listen: false)
                                                      .updateIpContent(
                                                          _idController.text);
                                                  appData.connect = false;
                                                }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyHomePage(
                                                                title:
                                                                    "Crazy Display")));
                                              });
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: appData.colorSec),
                                            )),
                                      ],
                                    );
                                  });
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Login Incorrect'),
                                  content: Text(
                                      'Please check your username and password. Features are disabled while not logged in.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            appData.showLoginForm = false;
                                            appData.connect = true;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage(
                                                            title:
                                                                "Crazy Display")));
                                          });
                                        },
                                        child: Text('OK',
                                            style: TextStyle(
                                                color: appData.colorSec))),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
