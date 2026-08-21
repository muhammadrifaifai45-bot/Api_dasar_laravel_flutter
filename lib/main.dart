import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokoxiezz/layar/home_page.dart';
import 'layar/LoginxiezPage.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

Future<bool>cekLogin()async{
SharedPreferences pref =await SharedPreferences.getInstance();
return pref.getString("token")!=null;
}
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "TOKO XIE",
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blueGrey,
    ),
    home: FutureBuilder(future: cekLogin(),builder: (context, snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if(snapshot.data==true){
        return const HomePage();
      }
      return const LoginPage();
    }
    )
   );
  }
}