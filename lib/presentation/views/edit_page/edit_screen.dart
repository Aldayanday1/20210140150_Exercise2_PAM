import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_static.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_static_edit.dart';
import 'package:kulinerjogja/presentation/views/register_page/widgets/radio_button.dart';

class EditKuliner extends StatefulWidget {
  final Kuliner kuliner;
  const EditKuliner({Key? key, required this.kuliner}) : super(key: key);

  @override
  State<EditKuliner> createState() => _EditKulinerState();
}

class _EditKulinerState extends State<EditKuliner> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;
  LatLng? _selectedLocation;

  // terkait dengan id kuliner dengan settingan default -> 0
  int _idKuliner = 0;

  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _deskripsi = TextEditingController();

  // ----------- GET IMAGE -------------
  Future<void> getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

// ----------- GET PHOTO -------------
  Future<void> takePhoto() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Kategori? selectedKategori;

  // ------------ VALIDATE TEXT ---------------

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini tidak boleh kosong';
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  @override
  void didUpdateWidget(EditKuliner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeData();
  }

  void _initializeData() {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Kuliner) {
      Kuliner kuliner = arguments;
      _idKuliner = kuliner.id;
      _nama.text = kuliner.nama;
      _deskripsi.text = kuliner.deskripsi;
      selectedKategori = kuliner.kategori;
      _image = File(kuliner.gambar);
      setState(() {
        _alamat = kuliner.alamat;
        _selectedLocation = LatLng(kuliner.latitude, kuliner.longitude);
      });
    }
  }

  void _onLocationChanged(LatLng location, String address) {
    setState(() {
      _selectedLocation = location;
      _alamat = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        title: Text("Edit Screen"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _nama,
                  validator: _validateText,
                ),
                SizedBox(height: 16),
                Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Masukkan Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _deskripsi,
                  validator: _validateText,
                ),
                SizedBox(height: 16),
                // ----------- RADIO BUTTON ----------------
                RadioButton(
                  selectedKategori: selectedKategori,
                  onKategoriSelected: (Kategori? value) {
                    setState(() {
                      selectedKategori = value;
                    });
                  },
                ),
                Text(
                  "Alamat",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                GestureDetector(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Color.fromARGB(255, 243, 243, 243),
                    child: Container(
                      height: 200,
                      child: _selectedLocation != null
                          ? StaticMapEdit(
                              location: _selectedLocation!,
                              onLocationChanged: _onLocationChanged,
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                if (_alamat != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Alamat diperbarui: $_alamat',
                      style: TextStyle(
                        color: Color.fromARGB(255, 74, 177, 77),
                      ),
                    ),
                  ),

                SizedBox(height: 16),
                Text(
                  "Gambar",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150,
                  child: _image == null
                      ? Text(
                          "Tidak ada gambar yang dipilih!",
                          style: TextStyle(
                            color: Color.fromARGB(255, 192, 95, 95),
                          ),
                        )
                      : Container(
                          width: 300,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _image!.path.startsWith('http')
                                ? Image.network(
                                    _image!.path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text("Pilih Gambar"),
                    ),
                    ElevatedButton(
                      onPressed: takePhoto,
                      child: Text("Ambil Foto"),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 25),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          DateTime now = DateTime.now();

                          var kuliner = Kuliner(
                            id: _idKuliner,
                            nama: _nama.text,
                            deskripsi: _deskripsi.text,
                            alamat: _alamat!,
                            latitude: _selectedLocation?.latitude ?? 0.0,
                            longitude: _selectedLocation?.longitude ?? 0.0,
                            gambar: _image != null &&
                                    _image!.path != widget.kuliner.gambar
                                ? _image!.path
                                : '', // Gunakan nilai string kosong jika tidak ada perubahan pada gambar
                            kategori: selectedKategori!,
                            createdAt: widget.kuliner.createdAt,
                            updatedAt: now,
                          );

                          var result = await KulinerController().updateKuliner(
                            kuliner,
                            _image != null &&
                                    _image!.path != widget.kuliner.gambar
                                ? _image
                                : null,
                          );

                          if (result['success']) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(),
                              ),
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'])),
                          );
                        }
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
