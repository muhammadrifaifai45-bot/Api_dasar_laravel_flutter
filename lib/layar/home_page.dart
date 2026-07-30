import 'package:flutter/material.dart';
import 'package:tokoxiezz/models/product.dart';
import 'package:tokoxiezz/services/setingan_api.dart';
import 'package:tokoxiezz/widget/product_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SetingganApi api=SetingganApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Produk Xiezz Shopp"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: api.getProducts(), 
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index){
            return ProductCard(
              Product:snapshot.data![index],
            );
          },
        );
        }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:(){

          },
          child: const Icon(Icons.add), 
          ),
    );
  }
}