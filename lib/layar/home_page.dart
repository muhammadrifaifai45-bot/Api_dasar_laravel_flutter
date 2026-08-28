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
  TextEditingController searchController = TextEditingController();
  List<Product> semuaproduk = [];
  List<Product> hasilpencarian = [];

  Future<List<Product>>? futureProduk;

  void initState() {
    super.initState();

    futureProduk = api.getProducts();
  }

  void Cariproduk(String keyword) {
    hasilpencarian = semuaproduk.where((produk) {
      return produk.nama.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
    setState(() {});
  }

  double totalstok() {
    return semuaproduk.fold(
      0,
      (total, item) => total + (item.harga * item.stock),
    );
  }

  double totalnilai() {
    return semuaproduk.fold(
      0,
      (total, item) => total + (item.harga * item.stock),
    );
  }

  void refreshData() {
    setState(() {
      futureProduk = api.getProducts();
    });
  }

  Future<void> hapusProduct(Product product) async {
    bool? konfirmasi = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("KONFIRMASI"),
            content:
                Text("Anda yakin ingin menghapus data ini ${product.nama}?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("BATAL"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("ya"),
              ),
            ],
          );
        });
    if (konfirmasi == true) {
      bool hasil = await api.deleteProduct(product.id!);
      if (hasil) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("produk berhasil di hapus"),
        ));
        setState(() {});
      }
    }
  }

  void dispose() {
    searchController.dispose();
    super.dispose();
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.green,
        foregroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<Product>>(
            future: api.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            size: 80,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(snapshot.error.toString(),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: refreshData,
                            child: const Text("Gagal Harap Coba Lagi"),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                semuaproduk = [];
                hasilpencarian = [];
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory,
                            size: 80,
                            color: Colors.green,
                          ),
                          const Text(
                            "Berhasil Mnegambil data",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }

              semuaproduk = snapshot.data!;
              if (searchController.text.isEmpty) {
                hasilpencarian = semuaproduk;
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "HALLO BUDY",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
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
                              title: "produk",
                              value: "${semuaproduk.length}",
                              icon: Icons.shopping_bag,
                              color: Colors.blueAccent)),
                      Expanded(
                          child: DashboardCard(
                              title: "stok",
                              value: "${totalstok()}",
                              icon: Icons.inventory,
                              color: Colors.blueAccent)),
                      Expanded(
                          child: DashboardCard(
                              title: "nilai",
                              value: "${totalnilai()}",
                              icon: Icons.payment,
                              color: Colors.green)
                              ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(controller: searchController,
                  onChanged: Cariproduk,
                  decoration: InputDecoration(
                    hintText: "Cari produk yang anda inginkan ",
                    prefixIcon: const Icon(Icons.search,
                    ),
                    suffixIcon: searchController
                    .text
                    .isNotEmpty
                    ?IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: (){
                        searchController.clear();
                        Cariproduk("");
                      },
                      )

                      :null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                  ),
                  ),
                  const SizedBox(height: 15,)
                ],
              );

            

              // return ListView.builder(
              //   itemCount: snapshot.data!.length,
              //   itemBuilder: (context, index) {
              //     return ProductCard(
              //       product: snapshot.data![index],
              //       onEdit: () async {
              //         final hasil = await Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (_) => EditPage(
              //               product: snapshot.data![index],
              //             ),
              //           ),
              //         );
              //         if (hasil == true) {
              //           setState(() {});
              //         }
              //       },
              //       onDelete: () async {
              //         await hapusProduct(snapshot.data![index]);
              //       },
              //       onDetail: () async {
              //         await Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (_) =>
              //                 DetailProduct(product: snapshot.data![index]),
              //           ),
              //         );
              //         setState(() {});
              //       },
              //     );
              //   },
              // );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //navigasi ke form hasil
          final hasil = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddPage()));
          if (hasil == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
