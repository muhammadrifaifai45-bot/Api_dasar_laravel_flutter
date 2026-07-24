import 'package:flutter/material.dart';
import 'home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController=TextEditingController();
  final sandiController=TextEditingController();
  bool isLoading=false;

  // method login
  void login(){
    if(emailController.text == "rifai45@gmail.com" && sandiController.text == "kuyakuya"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const HomePage(),
      ),
      
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text("EMAIL ATAU SANDI ANDA SALAH COBA LAGI MAS😒"),
        ),
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