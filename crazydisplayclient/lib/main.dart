import 'package:crazydisplayclient/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _ipController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appData.colorSec,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: TextField(
                controller: _ipController,
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
                    labelText: 'IP',
                    ),
                ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: TextField(
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
              width: 150,
              child: ElevatedButton(
                
                onPressed: () {
                  Provider.of<AppData>(context, listen: false).updateIpContent(_ipController.text);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(appData.colorSec), // Color de fondo del botón
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Color del texto e ícono
                  shadowColor: MaterialStateProperty.all<Color>(Colors.black), // Color de la sombra
                  elevation: MaterialStateProperty.all<double>(5.0),
                ),
                child: const Text('Send'), // Texto que se muestra en el botón
              ),
            )
            
          ],
        ),
      ),
    );
  }
}
