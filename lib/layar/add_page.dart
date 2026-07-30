import 'package:flutter/material.dart';
import 'package:tokoxiezz/models/product.dart';
import 'package:tokoxiezz/services/setingan_api.dart';

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
    return const Placeholder();


    
  }
}