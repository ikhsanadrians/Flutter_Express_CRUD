import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  String hasilSearch = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  List<Map<String, dynamic>> apiData = [];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<void> fetchData(String searchQuery) async {
      final response =
          await http.get(Uri.parse(hasilSearch == '' ? 'http://10.10.18.21:3002/mahasiswa?q=null' : 'http://10.10.18.21:3002/mahasiswa?q=$searchQuery'));

      if (response.statusCode == 200) {
        // Berhasil mengambil data
        final jsonData = json.decode(response.body);
        setState(() {
          final data = jsonData['data'];
          if (data != null) {
            apiData = List<Map<String, dynamic>>.from(data);
            print(apiData);
          }
        });
      } else {
        // Gagal mengambil data
        print('Failed to load data. Status code: {response.statusCode}');
      }
    }

    void initState() {
      super.initState();
      _pageController = PageController(initialPage: 0);
      fetchData(hasilSearch);
    }

    void _onItemTapped(int index) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      setState(() {
        _selectedIndex = index;
      });

      if (index == 1) {
        fetchData(hasilSearch); // Muat ulang data saat tab 'Data Mahasiswa' dipilih
      }
    }

    Future<void> postData(String name, String address, String phoneNumber,
        String photoUrl) async {
      final Uri uri = Uri.parse('http://10.10.18.21:3002/mahasiswa');
      final Map<String, String> data = {
        'name': name,
        'address': address,
        'phone_number': phoneNumber,
        'photo': photoUrl
      };
      final response = await http.post(
        uri,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      fetchData(hasilSearch);
    }

    void clearForm() {
      nameController.clear();
      addressController.clear();
      phoneController.clear();
      imageController.clear();
    }

    Future<void> submitForm() async {
      String name = nameController.text;
      String address = addressController.text;
      String phone = phoneController.text;
      String image = imageController.text;
      if (image == null || image.isEmpty) {
        image = "noimg";
      }
      postData(name, address, phone, image); // Panggil metode postData
      fetchData(hasilSearch);
      clearForm();
      _onItemTapped(1);
    }

    Future<void> editData(int id) async {
       setState(() {
            hasilSearch = "";
      });
      final responses =
          await http.get(Uri.parse("http://10.10.18.21:3002/mahasiswa/$id/show"));
      if (responses.statusCode == 200) {
        final jsonData = jsonDecode(responses.body);
        if (jsonData['data'] != null) {
          // print(jsonData['data'][0]['name']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Edit(
                id: jsonData['data'][0]['id'],
                name: jsonData['data'][0]['name'],
                address: jsonData['data'][0]['address'],
                phone: jsonData['data'][0]['phone_number'],
                image: jsonData['data'][0]['photo'],
                fetchCallback: (){
                  fetchData("");
                },
              ),
            ),
          );
        }
      }
    }

    Future <void> deleteData(int id) async {
        final responses = await http.delete(Uri.parse("http://10.10.18.21:3002/mahasiswa/$id"));
        if(responses.statusCode == 200) {
            fetchData(hasilSearch);
        }
    }




    return Scaffold(
      appBar: AppBar(
        title: Text('Crud'),
      ),
      body: PageView(controller: _pageController, children: [
        Center(
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
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text('Cari Data'),
                      TextFormField(
                        onChanged: (value) {
                            setState(() {
                                hasilSearch = value;
                                fetchData(value);
                            });
                        },
                      ),
                    ],
                  )),
              Column(
                children: [
                  for (var itemData in apiData)
                    Container(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(itemData['name']),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alamat',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(itemData['address']),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nomor HP',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(itemData['phone_number']),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Foto',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                8), // Berikan jarak antara teks dan gambar (opsional)
                                        itemData['photo'] == "noimg"
                                            ? Text("Gambar tidak ada")
                                            : Image.network(
                                                itemData['photo'],
                                                height:
                                                    100, // Sesuaikan tinggi gambar sesuai kebutuhan Anda
                                                width:
                                                    100, // Sesuaikan lebar gambar sesuai kebutuhan Anda
                                                fit: BoxFit
                                                    .cover, // Atur jenis pemadanan gambar sesuai kebutuhan Anda
                                              ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                      TextButton(onPressed: (){
                                        editData(itemData['id']);
                                      }, child: Icon(Icons.edit)),
                                      TextButton(onPressed: (){
                                        deleteData(itemData['id']);
                                      }, child: Icon(Icons.delete))

                                    ],)
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        )
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Data Mahasiswa',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
