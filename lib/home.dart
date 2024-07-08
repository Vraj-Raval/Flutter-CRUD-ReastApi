import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restapi/AddApi.dart';
import 'package:restapi/Update.dart';
import 'package:restapi/GetData.dart'; // Replace with your actual path

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<dynamic>> getDataFromApi() async {
    final response = await http.get(
      Uri.parse("https://668c16cc0b61b8d23b0c627f.mockapi.io/sample"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _navigateToAddDataScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddApi()),
    );

    if (result == true) {
      setState(() {
        // Refresh the list
      });
    }
  }

  void _navigateToUpdateDataScreen(Map contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateApi(contact: contact)),
    );

    if (result == true) {
      setState(() {
        // Refresh the list
      });
    }
  }

  void _deleteData(String id) async {
    final response = await http.delete(
      Uri.parse("https://668c16cc0b61b8d23b0c627f.mockapi.io/sample/$id"),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Refresh the list
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    }
  }

  void _navigateToDetailScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetDataById(id: id)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data List'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<List<dynamic>>(
                  future: getDataFromApi(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No data available'),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var contact = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              _navigateToDetailScreen(contact['id']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              contact['name'].toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              contact['address'].toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              contact['phone'].toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                        onPressed: () {
                                          _navigateToUpdateDataScreen(contact);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          _deleteData(contact['id']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDataScreen,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }
}
