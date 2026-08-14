import 'package:flutter/material.dart';

class Product{
  int? id;
  String nama;
  double harga;
  int stock;
  String deskripsi;
  String? gambar;
  Product({
    this.id,
    required this.nama,
    required this.harga,
    required this.stock,
    required this.deskripsi,
    this.gambar
  });
  factory Product.fromJson(Map<String,dynamic>json){
    return Product(
      id:json['id'],
      nama:json['nama'],
      harga:json['harga'].toDouble(),
      stock:json['stock'],
      deskripsi:json['deskripsi'],
      gambar:json['gambar']
    );
  }
  
  Map<String,dynamic>toJson(){
    return{
      "id":id,
      "nama":nama,
      "harga":harga,
      "stock":stock,
      "deskripsi":deskripsi,
      "gambar":gambar,
    };
  }
  
}