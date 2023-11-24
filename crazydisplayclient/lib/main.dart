import 'package:crazydisplayclient/appData.dart';
import 'package:crazydisplayclient/clientLayout.dart';
import 'package:crazydisplayclient/messageLayout.dart';
import 'package:crazydisplayclient/signInLayout.dart';
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
            IconButton(
              icon: Icon(Icons.account_circle_sharp), // or Icons.person
              onPressed: () {
                // Set showLoginForm to true when the icon button is pressed
                setState(() {
                  appData.showLoginForm = true;
                });
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: appData.colorSec,
              ),
              child: Text(
                'Client and message list',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // Add your sidebar content here
            ListTile(
              title: Text('Clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesPage()),
                );
              },
            ),
            ListTile(
              title: Text('Messages'),
              onTap: () {
                if (appData.connectionStatus == ConnectionStatus.connected) {
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
            // Add more items as needed
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
                  child: Row(
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
                        child: const Text('Send'),
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
}
