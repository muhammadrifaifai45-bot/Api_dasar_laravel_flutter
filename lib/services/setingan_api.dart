import 'dart:convert';
// import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:tokoxiezz/models/product.dart';

class SetingganApi{
  static const String baseUrl ="http://127.0.0.1:8000/api";
Future<List<Product>>getProducts() async{
  final response=await http.get(
    Uri.parse("${baseUrl}/products"),
  );
  if(response.statusCode==200){
    List jsonData=jsonDecode(response.body);

    return jsonData
    .map((e)=>Product.fromJson(e))
    .toList();
  }else{
    throw Exception("GAGAL MENGAMBIL DATA DARI API");
  }
}

Future<bool>storeProducts(
  Product product,
)async{
  final response=await http.post(
    Uri.parse("${baseUrl}/products"),
    body:{
      "nama":product.nama,
      "harga":product.harga.toString(),
      "stock":product.stock.toString(),
      "deskripsi":product.deskripsi.toString()
    },
    );
    return response.statusCode==201;
}

  Future<bool>updateProduct(Product product)async{
    final response =await http.put(
      Uri.parse("${baseUrl}/products/${product.id}"),
       body:{
      "nama":product.nama,
      "harga":product.harga.toString(),
      "stock":product.stock.toString(),
      "deskripsi":product.deskripsi.toString()
    },
    );
    return response.statusCode==200;
  }

  Future<bool>deleteProduct(int id)async{
    final response=await http.delete(
      Uri.parse("${baseUrl}/products/$id"),
    );
    return response.statusCode==200;
  }

}