import 'package:flutter/material.dart';
import 'package:tokoxiezz/services/setingan_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tokoxiezz/models/product.dart';
import 'dart:io';



class EditPage extends StatefulWidget {
  final Product product;
  const EditPage({super.key, required this.product});

  @override
  State<EditPage> createState() => _EditPageState();
}


class _EditPageState extends State<EditPage> {
  final _formKey=GlobalKey<FormState>();
  final namaController=TextEditingController();
  final hargaController=TextEditingController();
  final stockController=TextEditingController();
  final deskripsiController=TextEditingController();
  final SetingganApi api=SetingganApi();
  bool loading=false;
  final picker=ImagePicker();
  File? image;

  void initState(){
    super.initState();
    namaController.text=widget.product.nama;
    hargaController.text=widget.product.harga.toString();
    stockController.text=widget.product.stock.toString();
    deskripsiController.text=widget.product.deskripsi;
  }

  Future<void> pilihGambar() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }
  Future <void>editData()async{
     if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      loading=true;
    });
    Product product=Product(
      id: widget.product.id,
      nama:namaController.text,
      harga:double.parse(hargaController.text),
      stock:int.parse(stockController.text),
      deskripsi: deskripsiController.text,
    );
    bool berhasil=await api.updateProduct(product);
    setState(() {
      loading=false;
    });
    if(berhasil){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PRODUK BERHASIL DI UPDATE")
            ),
        );
        Navigator.pop(context,true);
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PRODUK GAGAL DI Update")
            ),
        );
    }
    
    

  }
  Future<void>konfirmasiUpdate()async{
      bool?jawaban=await showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Apakah anda benar benar yakin data akan di update"),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context,false);
              },
               child: const Text("Batal")
               ),
               ElevatedButton(onPressed: (){
                  Navigator.pop(context,true);
               }, 
               child: const Text("oke"),
               )
            ],
          );
        },
      );
      if (jawaban==true){
        editData();
      }
    }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text(
          "UPDATE PRODUK"
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
         child: Center(
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: pilihGambar,
                  child: image == null
                      ? Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.blueGrey),
                          child: const Icon(
                            Icons.add_a_photo,
                            size: 60,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            image!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
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
                  onPressed: loading?null:konfirmasiUpdate,
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
            ],
    ),
         )
      )
     );
     
  }
}