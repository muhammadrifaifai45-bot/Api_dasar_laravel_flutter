import 'package:flutter/material.dart';
import 'package:tokoxiezz/layar/LoginxiezPage.dart';
import 'package:tokoxiezz/layar/add_page.dart';
import 'package:tokoxiezz/layar/detail_product.dart';
import 'package:tokoxiezz/layar/edit_page.dart';
import 'package:tokoxiezz/models/product.dart';
import 'package:tokoxiezz/services/setingan_api.dart';
import 'package:tokoxiezz/widget/dashboard_card.dart';
import 'package:tokoxiezz/widget/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SetingganApi api = SetingganApi();
  final TextEditingController searchController = TextEditingController();

  List<Product> semuaproduk = [];
  List<Product> hasilpencarian = [];
  String filterHarga = "semua";
  String sorting = "Nama A-Z";

  @override
  void initState() {
    super.initState();
    loadingproducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadingproducts() async {
    try {
      final data = await api.getProducts();
      if (!mounted) return;
      setState(() {
        semuaproduk = data;
        hasilpencarian = List.from(data);
      });
      prosesdata(); // Terapkan filter & sorting setelah data dimuat
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal Mengambil Data Mohon maaf; $e'),
        ),
      );
    }
  }

  void prosesdata() {
    List<Product> data = List.from(semuaproduk);

    // Logika Pencarian
    final keyword = searchController.text.toLowerCase();
    if (keyword.isNotEmpty) {
      data = data.where((product) {
        return product.nama.toLowerCase().contains(keyword);
      }).toList();
    }

    // Logika Filter Harga
    if (filterHarga == "Dibawah Rp 500000") {
      data = data.where((product) {
        return product.harga < 500000;
      }).toList();
    } 
    else if (filterHarga == "Rp. 500000 - Rp. 2000000") {
      data = data.where((product) {
        return product.harga >= 500000 && product.harga <= 10000000;
      }).toList();
    } 
    else if (filterHarga == "Diatas Rp 2.000.000") {
      data = data.where((product) {
        return product.harga > 2000000;
      }).toList();
    }

    // Logika Sorting
    if (sorting == "Nama A-Z") {
      data.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    } 
    
    else if (sorting == "Nama Z-A") {
      data.sort((b, a) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()));
    }
     else if (sorting == "Harga terendah") {
      data.sort((a, b) => a.harga.compareTo(b.harga));
    } 
    else if (sorting == "Harga tertinggi") {
      data.sort((a, b) => b.harga.compareTo(a.harga));
    } 
    else if (sorting == "Stok teredikit") {
      data.sort((a, b) => a.stock.compareTo(b.stock));
    }
     else if (sorting == "Stok terbanyak") {
      data.sort((a, b) => b.stock.compareTo(a.stock));
    }

    setState(() {
      hasilpencarian = data;
    });
  }

  void cariProduk(String keyword) {
    prosesdata();
  }
  void PilihFilterHarga(String? pilihanuser){
    if(pilihanuser==null)return;
    setState(() {
      filterHarga=pilihanuser;
    });
    prosesdata();
  }
   
  void pilihSorting(String? pilihanuser){
    if(pilihanuser==null)return;
    setState(() {
      sorting=pilihanuser;
    });
    prosesdata();
  }


  int totalStok() {
    return semuaproduk.fold(0, (total, item) => total + item.stock);
  }

  double totalNilai() {
    return semuaproduk.fold(
      0,
      (total, item) => total + (item.harga * item.stock),
    );
  }

  String formatRupiah(int angka) {
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

  void refreshData() {
    loadingproducts();
  }

  Future<void> hapusProduct(Product product) async {
    bool? konfirmasi = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("KONFIRMASI"),
          content: Text("Anda yakin ingin menghapus data ini ${product.nama}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("BATAL"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("YA"),
            ),
          ],
        );
      },
    );

    if(konfirmasi == true){
      return;
    }

    if (konfirmasi == true) {
      bool hasil = await api.deleteProduct(product.id!);
      if(!mounted) return;
      if (hasil) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Produk berhasil dihapus"),
        )
        );
      await loadingproducts();
      }else{
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:))
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
            onPressed: () async {
              await api.logout();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPage()),
          );
          if (hasil == true) {
            loadingproducts();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: loadingproducts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HALLO BUDY",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "SELAMAT DATANG PADA APLIKASI TOKO XIEZZ",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Produk",
                    value: "${semuaproduk.length}",
                    icon: Icons.shopping_bag,
                    color: Colors.blueAccent,
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    title: "Stok",
                    value: "${totalStok()}",
                    icon: Icons.inventory,
                    color: Colors.blueAccent,
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    title: "Total Asset",
                    value: formatRupiah(totalNilai().toInt()),
                    icon: Icons.payment,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 15),
            const Text(
              "DAFTAR PRODUK TOKO XIEZZ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text("kelola produk dengan muudah"),
            TextField(
              controller: searchController,
              onChanged: cariProduk,
              decoration: InputDecoration(
                hintText: "Cari produk yang anda inginkan",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          cariProduk("");
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: filterHarga,
                decoration: const InputDecoration(
                  labelText: 'Filter Harga',
                  prefixIcon: const Icon(Icons.filter_alt
                  ),
                  border: OutlineInputBorder(),
                ),
                items: const[
                  DropdownMenuItem(
                    value: "semua",
                    child: Text("Semuaproduk"),
                    
                  ),
                    DropdownMenuItem(
                    value: "Dibawah Rp 500000",
                    child: Text("Dibawah Rp 50000"),
                    
                  ),
                    DropdownMenuItem(
                    value: "Rp. 500000 - Rp. 2000000",
                    child: Text("Rp. 500000 - Rp. 2000000"),
                    
                  ),
                    DropdownMenuItem(
                    value: "di atas Rp.2.000.000",
                    child: Text("di atas Rp.2.000.00"),                    
                  )                  
                ],
                onChanged: PilihFilterHarga,
              ),

              const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                value: sorting,
                decoration: const InputDecoration(
                  labelText: 'Urutkan produk',
                  prefixIcon: const Icon(Icons.sort
                  ),
                  border: OutlineInputBorder(),
                ),
                items: const[
                  DropdownMenuItem(
                    value: "Nama A-Z",
                    child: Text("Nama A-Z"),
                    
                  ),
                    DropdownMenuItem(
                    value: "Nama Z-A",
                    child: Text("Nama Z-A"),
                    
                  ),
                    DropdownMenuItem(
                    value: "Harga terendahh",
                    child: Text("Harga Terendahh"),
                    
                  ),
                    DropdownMenuItem(
                    value: "Harga tertinggi",
                    child: Text("Harga tertinggi"),                    
                  ),                  
                    DropdownMenuItem(
                    value: "Stok teredikitt",
                    child: Text("Stok Sedikit"),
                    
                  ),
                    DropdownMenuItem(
                    value: "Stok Banyak",
                    child: Text("Stok banyak"),                    
                  )                  
                ],
                onChanged: pilihSorting,
              ),

              

            const SizedBox(height: 15),
            if (hasilpencarian.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    "PRODUK TIDAK DITEMUKAN",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              ...hasilpencarian.map((product) {
                return ProductCard(
                  product: product,
                  // onTap:()async{

                  // }
                  onEdit: () async {
                    final hasil = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPage(product: product),
                      ),
                    );
                    if (hasil == true) {
                    loadingproducts();
                    }
                  },
                  onDelete: () {
                    hapusProduct(product);
                  },
                  onDetail: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailProduct(product: product),
                      ),
                    );
                    refreshData();
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:tokoxiezz/layar/LoginxiezPage.dart';
// import 'package:tokoxiezz/layar/add_page.dart';
// import 'package:tokoxiezz/layar/detail_product.dart';
// import 'package:tokoxiezz/layar/edit_page.dart';
// import 'package:tokoxiezz/models/product.dart';
// import 'package:tokoxiezz/services/setingan_api.dart';
// import 'package:tokoxiezz/widget/dashboard_card.dart';
// import 'package:tokoxiezz/widget/product_card.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final SetingganApi api = SetingganApi();
//   TextEditingController searchController = TextEditingController();
//   List<Product> semuaproduk = [];
//   List<Product> hasilpencarian = [];
//   String FilterHarga = "semua";
//   String sorting = "Nama A-Z";

//   Future<void> loadingproducts() async {
//     try {
//       final data = await api.getProducts();
//       if (!mounted) return;
//       setState(() {
//         semuaproduk = data;
//         hasilpencarian = List.from(data);
//       });
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Gagal Mengambil Data Mohon maaf;$e'),
//         ),
//       );
//     }
//   }

//   void initState() {
//     super.initState();

//     loadingproducts();
//   }

//   void prosesdata() {
//     List<Product> data = List.from(semuaproduk);
//     //logic pencarian
//     final keyword = searchController.text.toLowerCase();
//     if (keyword.isNotEmpty) {
//       data = data.where((Product) {
//         return Product.nama.toLowerCase().contains(keyword);
//       }).toList();
//     }

//     if (FilterHarga == "Dibawah Rp 500000") {
//       data = data.where((Product) {
//         return Product.harga < 50000;
//       }).toList();
//     }
//     if (FilterHarga == "Rp. 500000 - Rp. 10000000") {
//       data = data.where((Product) {
//         return Product.harga >= 500000 && Product.harga <= 200000;
//       }).toList();
//     }
//     if (FilterHarga == "Diatas Rp 2.000.000") {
//       data = data.where((Product) {
//         return Product.harga > 2000000;
//       }).toList();
//     }

//     //sorting

    // if (sorting == "Nama A-Z") {
    //   data.sort(
    //     (a, b) => a.nama.toLowerCase().compareTo(
    //           b.nama.toLowerCase(),
    //         ),
    //   );
    // }

//     if (sorting == "Nama Z-A") {
//       data.sort(
//         (b, a) => b.nama.toLowerCase().compareTo(
//               a.nama.toLowerCase(),
//             ),
//       );
//     }

//     if (sorting == "Harga terendah") {
//       data.sort(
//         (a, b) => a.harga.compareTo(b.harga),
//       );
//     }

//     if (sorting == "Harga tertinggi") {
//       data.sort(
//         (a, b) => b.harga.compareTo(a.harga),
//       );
//     }
//     if (sorting == "Stok teresedikit") {
//       data.sort(
//         (a, b) => a.stock.compareTo(b.harga),
//       );
//     }

//     if (sorting == "stok terbanyak") {
//       data.sort(
//         (a, b) => b.stock.compareTo(a.harga),
//       );
//     }
//     //simpan hasil
//     setState(() {
//       hasilpencarian = data;
//     });
//   }

//   void cariproduk(String keyword){
//     prosesdata();
//   }

//   void PilihFilterHarga(String? pilihanuser){
//     if(pilihanuser==null)return;
//     setState(() {
//       FilterHarga=pilihanuser;
//     });
//     prosesdata();
//   }

//   void pilihSorting(String? pilihanuser){
//     if(pilihanuser==null)return;
//     setState(() {
//       sorting=pilihanuser;
//     });
//     prosesdata();
//   }

//   int totalstok() {
//     return semuaproduk.fold(0, (total, item) => total + item.stock);
//   }

//   double totalnilai() {
//     return semuaproduk.fold(
//       0,
//       (total, item) => total + (item.harga * item.stock),
//     );
//   }

//   //format rupiah 

//    String formatrupiah(int angka){
//     String Hasil=angka.toString();
//     String result='';
//     int counter=0;
//     for(int i=Hasil.length-1;i>=0;i--){
//       result=Hasil[i]+result;
//       counter++;
//       if(counter==3 && i !=0){
//         result=".$result";
//         counter=0;
//       }
//     }
//     return "Rp$result";
//   }

//   void refreshData() {
//     setState(() {
//       // futureProduk = api.getProducts();
//     });
//   }

//   Future<void> hapusProduct(Product product) async {
//     bool? konfirmasi = await showDialog(
//         context: context,
//         builder: (_) {
//           return AlertDialog(
//             title: const Text("KONFIRMASI"),
//             content:
//                 Text("Anda yakin ingin menghapus data ini ${product.nama}?"),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context, false);
//                 },
//                 child: const Text("BATAL"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 },
//                 child: const Text("ya"),
//               ),
//             ],
//           );
//         });
//     if (konfirmasi == true) {
//       bool hasil = await api.deleteProduct(product.id!);
//       if (hasil) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("produk berhasil di hapus"),
//         ));
//         refreshData();
//       }
//     }
//   }

//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Data Produk Xiezz Shopp"),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await api.logout();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const LoginPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.red,
//       ),
//        floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           //navigasi ke form hasil
//           final hasil = await Navigator.push(
//               context, MaterialPageRoute(builder: (_) => const AddPage()));
//           if (hasil == true) {
//            loadingproducts();
//           }
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: RefreshIndicator(
//         onRefresh:loadingproducts,
//         child: ListView(
           
                  
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(12),
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "HALLO BUDY",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 5),
//                       const Text(
//                         "SELAMAT DATANG PADA APLIKASI TOKO XIEZZ",
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Expanded(
//                           child: DashboardCard(
//                               title: "produk",
//                               value: "${semuaproduk.length}",
//                               icon: Icons.shopping_bag,
//                               color: Colors.blueAccent)),
//                       Expanded(
//                           child: DashboardCard(
//                               title: "stok",
//                               value: "${totalstok()}",
//                               icon: Icons.inventory,
//                               color: Colors.blueAccent)),
//                       Expanded(
//                           child: DashboardCard(
//                               title: "Total Asset",
//                               value: "${totalnilai()}",
//                               icon: Icons.payment,
//                               color: Colors.green)),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   TextField(
//                     controller: searchController,
//                     onSubmitted: Cariproduk,
//                     decoration: InputDecoration(
//                       hintText: "Cari produk yang anda inginkan ",
//                       prefixIcon: const Icon(
//                         Icons.search,
//                       ),
//                       suffixIcon: searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 searchController.clear();
//                                 Cariproduk("");
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   const Text(
//                     "DAFTAR PRODUK TOKO XIEZZ",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   if (hasilpencarian.isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.all(30),
//                       child: Center(
//                           child: Text(
//                         "PRODUK TIDAK DI TEMUKAN",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       )),
//                     )
//                   else
//                     ...hasilpencarian.map((product) {
//                       return ProductCard(
//                         product: product,
//                         onEdit: () async {
//                           final hasil = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => EditPage(
//                                 product: product,
//                               ),
//                             ),
//                           );
//                           if (hasil == true) {
//                             refreshData();
//                           }
//                         },
//                         onDelete: () {
//                           hapusProduct(product);
//                         },
//                         onDetail: () async {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => DetailProduct(
//                                       product: product,
//                                     )),
//                           );
//                           refreshData();
//                         },
//                       );
//                     })
//                 ],
//               );

//               // return ListView.builder(
//               //   itemCount: snapshot.data!.length,
//               //   itemBuilder: (context, index) {
//               //     return ProductCard(
//               //       product: snapshot.data![index],
//               //       onEdit: () async {r
//               //         final hasil = await Navigator.push(
//               //           context,
//               //           MaterialPageRoute(
//               //             builder: (_) => EditPage(
//               //               product: snapshot.data![index],
//               //             ),
//               //           ),
//               //         );
//               //         if (hasil == true) {
//               //           setState(() {});
//               //         }
//               //       },
//               //       onDelete: () async {
//               //         await hapusProduct(snapshot.data![index]);
//               //       },
//               //       onDetail: () async {
//               //         await Navigator.push(
//               //           context,
//               //           MaterialPageRoute(
//               //             builder: (_) =>
//               //                 DetailProduct(product: snapshot.data![index]),
//               //           ),
//               //         );
//               //         setState(() {});
//               //       },
//               //     );
//               //   },
//               // );
//             }),
//       ),
     
//     );
//   }
// }
