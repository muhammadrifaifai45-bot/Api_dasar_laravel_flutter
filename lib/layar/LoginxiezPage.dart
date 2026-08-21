import 'package:flutter/material.dart';
import 'package:tokoxiezz/services/setingan_api.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController=TextEditingController();
  final sandiController=TextEditingController();
  final SetingganApi api = SetingganApi();
  bool isLoading=false;

  //method login data 
  
  Future<void>login()async{
    String? token=await api.login(
      emailController.text,
      sandiController.text,
    );
  if(token!=null){
    SharedPreferences pref= await SharedPreferences.getInstance();
    await pref.setString("token", token);
    Navigator.pushReplacement(
      context,
       MaterialPageRoute(builder:(_)=>const HomePage()),
       );
       
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("LOGIN GAGAL TIDAK BERHASIL MAAF") ,)
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.shop_rounded,
                size: 50,
                color:Colors.deepOrange,
                ),
                const SizedBox(height:20),
                const Text("APLIKASI TOKO XIEZZ",style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Masukan email",
                   prefixIcon: Icon(Icons.email),
                   border: OutlineInputBorder(),
                  ),
                ),

                 const SizedBox(height: 40),
                TextField(                  
                  controller: sandiController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Masukan Sandi yang telah di buat",
                   prefixIcon: Icon(Icons.lock),
                   border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                  onPressed:login, 
                  child: const Text("LOGIN",
                  style: TextStyle(fontSize: 26),
                  ),
                  ),
                )
              
              ],
            ),
          ),
        ),
      ),
    ) ;
  }
}