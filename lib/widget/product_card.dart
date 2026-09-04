import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
   final VoidCallback onDetail;

   
  const ProductCard({super.key,
  required this.product,
  required this.onEdit,
  required this.onDelete,
  required this.onDetail
  });

  String formatRupiah(double angka) {
    String hasil = angka.toString();
    String result = '';
    int counter = 0;
    for (int i = hasil.length - 1; i >= 0; i--) {
      result = hasil[i] + result;
      counter++;
      if (counter == 3 && i != 0) {
        result = ".$result";
        counter = 0;
      }
    }
    return "Rp$result";
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
    onTap: onDetail,
    
     child: Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: product.gambar==null || 
                product.gambar!.isEmpty
                ?Image.asset(
                  "asset/s25.jpg",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
                :Image.network("http://127.0.0.1:8000/storage/products/${product.gambar}",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace){
                    return Image.asset(
                      "asset/s25.jpg",
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      );
                    
                  },
                  

                ),
              ),
              ),
            Text(
              product.nama,   
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 10,),
             Text(
             "Harga:Rp${formatRupiah(product.harga)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
                const SizedBox(height: 10,),
                 Text(
             "Stok:${product.stock}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height:15),
               Text(
              product.deskripsi,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child:ElevatedButton.icon(
                  onPressed: onEdit,
                  icon:Icon(Icons.edit),
                  label: const Text("EDIT")
                  ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(child:ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onDelete,
                  icon:Icon(Icons.delete),
                  label: const Text("Hapus")
                  ),
                  ),
              ],
            )
          ],
        ),
      
      ), 
    ),
    );
   
  }
}