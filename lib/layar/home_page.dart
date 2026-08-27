import 'package:flutter/material.dart';
import 'package:tokoxiezz/layar/LoginxiezPage.dart';
import 'package:tokoxiezz/layar/add_page.dart';
import 'package:tokoxiezz/layar/detail_product.dart';
import 'package:tokoxiezz/layar/edit_page.dart';
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

  Future<void>hapusProduct(Product product)async{
    bool? konfirmasi=await showDialog(
      context: context,
      builder: (_){
        return AlertDialog(
          title: const Text("KONFIRMASI"),
          content: Text("Anda yakin ingin menghapus data ini ${product.nama}?"
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context,false);
              }, 
              child: const Text("BATAL"),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context,true);
                },
                 child: const Text("ya"),
                 ),
          ],
        );
      }
    );
    if(konfirmasi==true){
      bool hasil=await api.deleteProduct(product.id!);
      if(hasil){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:Text("produk berhasil di hapus"),
          )
          
        );
          setState(() {
      
    });

      }
    }
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Produk Xiezz Shopp"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: ()async{
              await api.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginPage(),
              ),
              );
            },
            ),
        ],
        backgroundColor: Colors.green,
        foregroundColor: Colors.red,
      ), 

      
      body:  RefreshIndicator(
        onRefresh: () async{
          setState(() {
            
          });
        },
      
      child: FutureBuilder<List<Product>>(
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
              product:snapshot.data![index],
              onEdit: ()async{
                final hasil=await Navigator.push(context,
                MaterialPageRoute(builder: (_)=>EditPage(product:snapshot.data![index],
                ),
                ),
                );
                if(hasil == true){
                  setState(() {
                    
                  });
                }
              },
              onDelete: ()async{
                await hapusProduct(snapshot.data![index]);
              },  
              onDetail: ()async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(_) =>
                    DetailProduct(product: snapshot.data![index]),
                    ),
                    
                );
                setState(() {
                  
                });
              },

              
            );
          },
        );
        }
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed:()async{
            //navigasi ke form hasil
            final hasil=await Navigator.push(
              context,MaterialPageRoute(
                builder:(_)=>const AddPage()
              )
            );
            if(hasil==true){
              setState(() {
                
              });
            }
          },
          child: const Icon(Icons.add), 
          ),
    );
  }
}