import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import 'dart:io';
// import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:tokoxiezz/models/product.dart';

class SetingganApi{
  static const String baseUrl ="http://127.0.0.1:8000/api";
Future<List<Product>>getProducts() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token=pref.getString("token")??"";

  final response=await http.get(
    Uri.parse("${baseUrl}/products"),

  headers:{
    "Authorization":"bearer $token",
    "Accept":"application/json",
    
  },
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
Future<bool> storeProducts(
  Product product,
  File? image,
) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token=pref.getString("token")??"";
  var request = http.MultipartRequest(
    "POST",
    Uri.parse("${baseUrl}/products"),
  );
  request.headers.addAll({
    "Authorization":"bearer $token",
    "Accept":"application/json",
    
  });

  request.fields["nama"] = product.nama;
  request.fields["harga"] = product.harga.toString();
  request.fields["stock"] = product.stock.toString();
  request.fields["deskripsi"] = product.deskripsi;

  if (image != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        "gambar",
        image.path,
      ),
    );
  }

  try {
    var response = await request.send();

    var responseBody = await response.stream.bytesToString();

    if (response.statusCode != 201) {
      throw Exception(
        "STATUS ${response.statusCode}: $responseBody",
      );
    }

    return true;
  } catch (e) {
    throw Exception("Gagal mengirim product: $e");
  }
}

// Future<bool>storeProducts(
//   Product product,
//   File? image,

// )async{
//   var request=http.MultipartRequest(
//     "POST", Uri.parse("${baseUrl}/products"),
//   );
//   request.fields["nama"]=product.nama;
//   request.fields["harga"]=product.harga.toString();
//   request.fields["stock"]=product.stock.toString();
//   request.fields["deskripsi"]=product.deskripsi;

//   if(image!=null){
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         "gambar", 
//         image.path,
//       ),
//     );
  
//   }
//   var response= await request.send();
//   return response.statusCode==20;
//   }


  Future<bool>updateProduct(Product product)async{
 SharedPreferences pref = await SharedPreferences.getInstance();
  String token=pref.getString("token")??"";
    final response =await http.put(
      Uri.parse("${baseUrl}/products/${product.id}"),
      headers:{
    "Authorization":"bearer $token",
    "Accept":"application/json",
    
  },
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
    SharedPreferences pref = await SharedPreferences.getInstance();
  String token=pref.getString("token")??"";
    final response=await http.delete(
      Uri.parse("${baseUrl}/products/$id"),
         headers:{
    "Authorization":"bearer $token",
    "Accept":"application/json",
    
  },
    );
    return response.statusCode==200;
  }

  Future<String?>login(
    String email,
    String password,
  )async{
    
    final response=await http.post(
      Uri.parse("${baseUrl}login"),
      body: {
        "email":email,
        "password":password,
      },
    );
    if (response.statusCode==200){
      final data=jsonDecode(response.body);
      return data["token"];
    }
    return null;
  }

}