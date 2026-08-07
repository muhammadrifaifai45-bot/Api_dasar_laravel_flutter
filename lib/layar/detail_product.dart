import 'package:flutter/material.dart';
import 'package:tokoxiezz/layar/edit_page.dart';
import 'package:tokoxiezz/models/product.dart';

class DetailProduct extends StatelessWidget {
  final Product product;

  const DetailProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
                tag: product.id!,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.computer,
                      size: 120,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 15),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.nama,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Icons.attach_money),
                            const SizedBox(width: 10),
                            Text(
                              "RP:${product.harga}",
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Icons.inventory),
                            const SizedBox(width: 10),
                            Text(
                              "STOK:${product.stock}",
                              style: const TextStyle(fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        const Text("DESKRIPSI",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.deskripsi,style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: const Text("EDIT PRODUK"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditPage(product: product),
                        ),
                         );
                    },
                  ),
                ),
                  const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.arrow_back),
                    label: const Text("Kembali"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
