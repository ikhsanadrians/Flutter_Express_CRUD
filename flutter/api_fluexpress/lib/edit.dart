import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Edit extends StatefulWidget {
  const Edit({
    Key? key,
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.image,
    required this.fetchCallback,
  }) : super(key: key);

  final int id;
  final String name;
  final String address;
  final String phone;
  final String image;
  final void Function()  fetchCallback;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController imageController = TextEditingController();
 

 void initState() {
      super.initState();
      nameController.text = widget.name;
      addressController.text = widget.address;
      phoneController.text = widget.phone;
      imageController.text = widget.image;
    
    }

 
  @override
  Widget build(BuildContext context) {

     Future<void> update(String name, String address, String phone, String image) async {
      final Map<String, String> data = {
        'name': name,
        'address': address,
        'phone_number': phone,
        'photo': image
      };
      final response = await http.put(
        Uri.parse("http://10.10.18.21:3002/mahasiswa/${widget.id}"),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        widget.fetchCallback();
        Navigator.pop(context);
      } else {
        // Handle error gracefully
        print('Failed to update data: {response.statusCode}');
        print(response.body);
      }
    }

    Future<void> submitForm() async {
      String name = nameController.text;
      String address = addressController.text;
      String phone = phoneController.text;
      String image = imageController.text;
      update(name, address, phone, image); // Panggil metode postData
      // fetchData();
    
    }

    return Scaffold(
       appBar: AppBar(title: Text('Edit ${widget.name}')),
       body:    Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Masukan Nama'),
                    TextField(
                      controller: nameController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Masukan Alamat'),
                    TextField(
                      controller: addressController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Masukan Nomor Hp'),
                    TextField(
                      controller: phoneController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Masukan URL Foto'),
                    TextField(
                      controller: imageController,
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  width: double.infinity,
                  color: Colors.purple,
                  child: TextButton(
                      onPressed: () {
                        submitForm();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      )))
            ],
          ),
        ),
    );
  }
}
