import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'appData.dart';
import 'package:crazydisplayclient/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MensajesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appData.colorSec,
        title: Text('Messages'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var message in appData.listMessages)
                GestureDetector(
                  onTap: () {
                    // Mostrar el prompt de confirmación
                    _mostrarPrompt(
                        context, _extraerTextoMensaje(message), appData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarPrompt(BuildContext context, String mensaje, AppData appData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to send this message?\n\n$mensaje'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Cerrar el cuadro de diálogo sin enviar el mensaje
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para enviar el mensaje
                appData.sendMessage(mensaje);
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  String _extraerTextoMensaje(String mensaje) {
    // Buscar la primera aparición de '[' y ']' en el mensaje
    final inicioTexto = mensaje.indexOf('[');
    final finTexto = mensaje.indexOf(']');

    if (inicioTexto != -1 && finTexto != -1) {
      // Extraer el texto antes de la primera aparición de '['
      final textoAntes = mensaje.substring(0, inicioTexto);

      // Extraer el texto después de la última aparición de ']'
      final textoDespues = mensaje.substring(finTexto + 2);

      // Combinar ambos textos
      String textoFinal = textoAntes + textoDespues;
      return textoFinal;
    } else {
      // Si no se encuentran corchetes, devolver el mensaje completo
      return mensaje;
    }
  }
}
