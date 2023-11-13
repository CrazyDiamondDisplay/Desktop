
// ignore_for_file: file_names, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';

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
  
  String? mySocketId;
  List<String> clients = [];
  String selectedClient = "";
  int? selectedClientIndex;
  String messages = "";

  bool file_saving = false;
  bool file_loading = false;

  AppData() {
    _getLocalIpAddress();
  }

  void clearIP(){
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

  void connectToServer() async {
    _socketClient ??= IOWebSocketChannel.connect("ws://$ip:$port");
    //sendMessage(message);
    _socketClient!.stream.listen(
      (message) {
        final data = jsonDecode(message);

        if (connectionStatus != ConnectionStatus.connected) {
          connectionStatus = ConnectionStatus.connected;
        }
      }
    );
  }

  void sendMessage(String message) {
  if (_socketClient != null) {
    _socketClient!.sink.add(message);
  } else {
    print("WebSocket not connected.");
  }
}

  disconnectFromServer() async {
    // Simulate connection delay
    _socketClient!.sink.close();
  }
}