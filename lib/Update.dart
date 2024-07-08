import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateApi extends StatefulWidget {
  final Map contact;

  UpdateApi({required this.contact});

  @override
  _UpdateApiState createState() => _UpdateApiState();
}

class _UpdateApiState extends State<UpdateApi> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact['name'];
    _addressController.text = widget.contact['address'];
    _phoneController.text = widget.contact['phone'];
  }

  Future<void> _updateData() async {
    setState(() {
      _isLoading = true;
    });

    final apiUrl = 'https://668c16cc0b61b8d23b0c627f.mockapi.io/sample/${widget.contact['id']}';
    final response = await http.put(
      Uri.parse(apiUrl),
      body: {
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 32),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (_formkey.currentState!.validate()) {
                      _updateData();
                    }
                  },
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
