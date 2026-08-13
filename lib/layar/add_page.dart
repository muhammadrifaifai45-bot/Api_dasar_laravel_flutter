import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tokoxiezz/models/product.dart';
import 'package:tokoxiezz/services/setingan_api.dart';
import 'dart:io';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey=GlobalKey<FormState>();
  final namaController=TextEditingController();
  final hargaController=TextEditingController();
  final stockController=TextEditingController();
  final deskripsiController=TextEditingController();
  final SetingganApi api=SetingganApi();
  bool loading=false;
  File? image;
  final picker=ImagePicker();

  Future<void>pilihGambar()async{
    final XFile? picked=await picker.pickImage(
      source: ImageSource.gallery,
      );
      if(picked !=null){
        setState(() {
          image=File(picked.path);
        });
      }
  }
  
  Future<void>simpanData()async{
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      loading=true;
    });
    Product product=Product(
      nama:namaController.text,
      harga:double.parse(hargaController.text),
      stock:int.parse(stockController.text),
      deskripsi: deskripsiController.text,
    );
    bool berhasil=await api.storeProducts(product);
    setState(() {
      loading=false;
    });
    if(berhasil){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PRODUK BERHASIL DI TAMBAHKAN")
            ),
        );
        Navigator.pop(context,true);
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PRODUK GAGAL DI TAMBAHKAN")
            ),
        );
    }
    
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TAMBAH PRODUK"
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Nama produk Wajib di isi ya";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: hargaController,
                decoration: const InputDecoration(
                  labelText: "Harga Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Harga produk Wajib di isi ya";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: "stok Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory)
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Stock produk Wajib di isi ya";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description)
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Deskripsi produk Wajib di isi ya";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: loading?null:simpanData,
                  icon:loading
                  ?const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                    
                  )
                  :const Icon(Icons.save),
                  label:Text(loading ?"menyimpan...":"SIMPAN"
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