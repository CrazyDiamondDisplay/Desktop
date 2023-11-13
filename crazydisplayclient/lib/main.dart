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

  final TextEditingController _idController = TextEditingController(text: "192.168.0.25");
  final TextEditingController _mssgController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appData.colorSec,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          children: [
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              SizedBox(
                width: 190*0.7,
                height: 247*0.7,
                child: Image.asset('assets/Morioh.png'),
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _idController,
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
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(appData.connect){
                        Provider.of<AppData>(context, listen: false).updateIpContent(_idController.text);
                        appData.connectToServer();
                        appData.connect = false;
                        appData.buttonText = "Disconnect";
                      }else{
                        appData.connect = true;
                        appData.buttonText = "Connect";
                        appData.disconnectFromServer();
                        appData.clearIP();
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(appData.colorSec), // Color de fondo del botón
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Color del texto e ícono
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black), // Color de la sombra
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  child: Text(appData.buttonText), // Texto que se muestra en el botón
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  
                  onPressed: () {
                    appData.sendMessage(_mssgController.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(appData.colorSec), // Color de fondo del botón
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Color del texto e ícono
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black), // Color de la sombra
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  child: const Text('Send'), // Texto que se muestra en el botón
                ),
                ],)
              )
              
            ],
          ),
        VerticalDivider(
          width: 40,  // Ancho total del divider (incluyendo márgenes)
          thickness: 1,  // Grosor de la línea
          color: appData.colorSec,  // Color de la línea
        ),
          ],
        )
      ),
    );
  }
}

