// ignore_for_file: file_names, camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';

enum ConnectionStatus {
  disconnected,
  disconnecting,
  connecting,
  connected,
}

class AppData with ChangeNotifier {
  Color colorSec = const Color.fromARGB(255, 172, 0, 80);
  String ip = "localhost";
  String port = "8888";

  String buttonText = "Connect";
  bool connect = true;

  IOWebSocketChannel? _socketClient;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;
  Completer<bool> _connectionCompleter = Completer<bool>();

  String? mySocketId;
  List<dynamic> listClients = [];
  List<String> listMessages = [];
  List<String> sentMessages = [];
  String selectedClient = "";
  int? selectedClientIndex;
  String? imagePath = "";
  String messages = "";
  String filePath = ("assets/listMessages.txt");

  bool file_saving = false;
  bool file_loading = false;
  bool isLoggedIn = false;
  bool imageIsLoaded = false;
  bool showLoginForm = true;
  String userName = "Not logged in";

  AppData() {
    _getLocalIpAddress();
  }

  void clearIP() {
    _socketClient = null;
  }

  void updateIpContent(String newContent) {
    ip = newContent;
    notifyListeners();
  }

  void _getLocalIpAddress() async {
    try {
      final List<NetworkInterface> interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4, includeLoopback: false);
      if (interfaces.isNotEmpty) {
        final NetworkInterface interface = interfaces.first;
        final InternetAddress address = interface.addresses.first;
        ip = address.address;
        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Can't get local IP address : $e");
    }
  }

  Future<bool> connectToServer(
      String ip, String username, String password) async {
    try {
      _socketClient ??= IOWebSocketChannel.connect("ws://$ip:$port");
      Completer<bool> connectionCompleter = Completer<bool>();

      _socketClient!.sink.add(
          "{\"type\": \"login\", \"user\": \"$username\", \"pass\": \"$password\"}");

      _socketClient!.stream.listen((message) {
        final data = jsonDecode(message);
        try {
          if (data['valid'] == "true") {
            if (connectionStatus != ConnectionStatus.connected) {
              connectionStatus = ConnectionStatus.connected;
              connectionCompleter.complete(true);
            }
          } else {
            disconnectFromServer();
            connectionCompleter.complete(false);
          }
        } catch (e) {}
      });
      return await connectionCompleter.future;
    } catch (e) {
      print("Error during connection: $e");
      return false;
    }
  }

  void sendMessage(String message) {
    if (_socketClient != null) {
      _socketClient!.sink.add("{\"type\": \"mssg\", \"text\":\"$message\"}");
      DateTime now = DateTime.now();
      String formattedDateTime =
          DateFormat('[yyyy-MM-dd HH:mm:ss]').format(now);
      if (!sentMessages.contains(message)) {
        sentMessages.add(message);
        listMessages.add("$formattedDateTime $message".trim());
        saveMessages(listMessages, filePath);
      }
    } else {
      print("WebSocket not connected.");
    }
  }

  disconnectFromServer() async {
    // Simulate connection delay
    if (_socketClient != null) {
      _socketClient!.sink.close();
      _socketClient = null;
      if (connectionStatus == ConnectionStatus.connected) {
        connectionStatus = ConnectionStatus.disconnected;
      }
    }
  }

  void saveMessages(List<String> messages, String filePath) {
    // Abre el archivo en modo de escritura
    var file = File(filePath);
    var sink = file.openWrite();

    // Escribe cada elemento de la lista en una línea del archivo
    for (var elemento in messages) {
      sink.writeln(elemento);
    }

    // Cierra el archivo
    sink.close();
  }

  List<String> loadMessages(String filePath) {
    // Abre el archivo en modo de lectura
    var file = File(filePath);

    // Lee todas las líneas del archivo y las guarda en una lista
    var lines = file.readAsLinesSync();

    return lines;
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      imagePath = result.files.single.path;
      notifyListeners();
    }
  }

  void sendImageViaWebSocket(String? image) async {
    try {
      if (image != null) {
        File imageFile = File(image);
        List<int> bytes = await imageFile.readAsBytes();

        String imageName = path.basename(image);

        saveSentImage(imageName, imageFile);

        // Encode image bytes to base64
        String base64Image = base64Encode(bytes);

        // Prepare a JSON object with image data
        Map<String, dynamic> imageData = {
          'type': 'img',
          'image': base64Image,
          'ext': image.substring(image.length - 3)
        };

        // Convert the JSON object to a string
        String jsonMessage = jsonEncode(imageData);

        // Send the image data via WebSocket
        _socketClient?.sink.add(jsonMessage);
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  Future<void> saveSentImage(String imageName, File image) async {
    try {
      String folderPath =
          '${Directory.current.path}/lib//media/imageGallery/$imageName';

      File file = File(folderPath);
      if (!file.existsSync()) {
        await image.copy(folderPath);
      }
    } catch (e) {
      print("Unable to copy image");
      print(e);
    }
  }

  List<File> showImageGallery() {
    String folderPath = '${Directory.current.path}/lib/media/imageGallery';
    Directory imgFolder = Directory(folderPath);

    List<FileSystemEntity> listContent = imgFolder.listSync();
    List<File> imgFiles = listContent.whereType<File>().toList();

    return imgFiles;
  }

  String extraerTextoMensaje(String mensaje) {
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
