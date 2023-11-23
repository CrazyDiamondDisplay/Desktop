import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'appData.dart';
import 'package:crazydisplayclient/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appData.colorSec,
        title: Text('Clients'),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Connected clients: ' +
                      appData.listClients[0][0].length.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Flutter clients')),
                    DataColumn(label: Text('Android clients')),
                  ],
                  rows: List.generate(
                    // Use the maximum length of both lists
                    appData.listClients[0][0].length >
                            appData.listClients[1][0].length
                        ? appData.listClients[0][0].length
                        : appData.listClients[1][0].length,
                    (index) => DataRow(
                      cells: [
                        DataCell(
                          index < appData.listClients[0][0].length
                              ? Text(appData.listClients[0][0][index])
                              : Text(
                                  ''), // Show empty text if the list doesn't have an entry at this index
                        ),
                        DataCell(
                          index < appData.listClients[1][0].length
                              ? Text(appData.listClients[1][0][index])
                              : Text(
                                  ''), // Show empty text if the list doesn't have an entry at this index
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
