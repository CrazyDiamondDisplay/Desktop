import 'dart:io';

import 'package:crazydisplayclient/appData.dart';
import 'package:crazydisplayclient/messageLayout.dart';
import 'package:crazydisplayclient/signInLayout.dart';
import 'package:crazydisplayclient/imageGalleryLayout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppData(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crazy Display',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Crazy Display'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _mssgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    appData.listMessages = appData.loadMessages(appData.filePath);
    appData.sentMessages = appData.loadMessages(appData.filePath);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appData.colorSec,
        title: Row(
          children: [
            // Add Spacer to fill the space on the left
            Spacer(),
            // Display user name
            Text(
              appData.userName,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 8), // Add spacing between user name and icon
            // Add an icon button to the app bar
            PopupMenuButton<String>(
              icon: Icon(Icons.account_circle_sharp),
              offset: Offset(0, 35),
              itemBuilder: (BuildContext context) {
                if (appData.isLoggedIn) {
                  return [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Log Out'),
                    ),
                  ];
                } else {
                  return [
                    PopupMenuItem<String>(
                      value: 'login',
                      child: Text('Log In'),
                    )
                  ];
                }
              },
              onSelected: (String value) {
                if (value == 'login') {
                  setState(() {
                    appData.showLoginForm = true;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Log Out'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  appData.disconnectFromServer();
                                  appData.isLoggedIn = false;
                                  appData.connect = !appData.connect;
                                  appData.userName = "Not logged in";
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Logged Out'),
                                          content:
                                              Text('You have been logged out'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('OK',
                                                    style: TextStyle(
                                                        color:
                                                            appData.colorSec)))
                                          ],
                                        );
                                      });
                                });
                              },
                              child: Text('Log out',
                                  style: TextStyle(color: appData.colorSec))),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  style: TextStyle(color: appData.colorSec))),
                        ],
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 64.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: appData.colorSec),
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                child: Center(
                  child:
                      Text('Features', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            // Add your sidebar content here
            ListTile(
              title: Text('Messages'),
              onTap: () {
                if (appData.isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MensajesPage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('You are not connected to the server'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the alert dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              title: Text('Image gallery'),
              onTap: () {
                if (appData.isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagesPage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('You are not connected to the server'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the alert dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
                SizedBox(
                  width: 190 * 0.7,
                  height: 247 * 0.7,
                  child: Image.asset('assets/Morioh.png'),
                ),
                const SizedBox(height: 70),
                SizedBox(
                  width: 500,
                  child: TextField(
                    controller: _mssgController,
                    cursorColor: appData.colorSec,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: appData.colorSec,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: appData.colorSec,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: appData.colorSec,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: appData.colorSec,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Message',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: appData.connect == false
                            ? () {
                                appData.sendMessage(_mssgController.text);
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors
                                    .grey; // Set the color for the disabled state
                              }
                              return appData
                                  .colorSec; // Set the color for other states
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        child: const Text('Send message'),
                      ),
                      _gap(),
                      IconButton(
                        color: appData.colorSec,
                        iconSize: 125,
                        onPressed: () {
                          setState(() {
                            appData.pickImage();
                            if (!appData.imageIsLoaded) {
                              appData.imageIsLoaded = !appData.imageIsLoaded;
                            }
                          });
                        },
                        icon: appData.imagePath!.isNotEmpty
                            ? Image.file(File(appData.imagePath!))
                            : Icon(Icons.image),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: appData.connect == false
                            ? () {
                                if (appData.imageIsLoaded) {
                                  appData
                                      .sendImageViaWebSocket(appData.imagePath);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content:
                                              Text('No image has been loaded'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Close the alert dialog
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors
                                    .grey; // Set the color for the disabled state
                              }
                              return appData
                                  .colorSec; // Set the color for other states
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        child: const Text('Send image'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (appData.showLoginForm) SignInPage1()
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 32);
}
