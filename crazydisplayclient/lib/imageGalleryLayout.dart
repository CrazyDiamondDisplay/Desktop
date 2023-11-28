import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'appData.dart';
import 'package:crazydisplayclient/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    List<File> images = appData.showImageGallery();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appData.colorSec,
          title: Text('Image Gallery'),
        ),
        body: Center(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            childAspectRatio: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(images.length, (index) {
              // Crea un widget Image para cada archivo en la lista
              return GestureDetector(
                  onTap: () {
                    String imagePath = images[index].path;
                    _mostrarPrompt(context, imagePath, appData);
                  },
                  child: Image.file(images[index], fit: BoxFit.cover));
            }),
          ),
        ));
  }
}

void _mostrarPrompt(BuildContext context, String imagePath, AppData appData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm', style: TextStyle(color: appData.colorSec)),
        content: Text('Do you want to send this image?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: appData.colorSec)),
          ),
          TextButton(
            onPressed: () {
              appData.sendImageViaWebSocket(imagePath);
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: Text('Send', style: TextStyle(color: appData.colorSec)),
          ),
        ],
      );
    },
  );
}
