import 'package:flutter/material.dart';
import 'package:tokoxiezz/services/setingan_api.dart';

class DashboardCard extends StatelessWidget {

   final String title;
   final String value;
   final IconData icon;
   final Color color;

   
  //  final SetingganApi penghubung = SetingganApi();
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color
    });
 


   
  @override

    Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 35,
              color: color,
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(title)
          ],
        ),
      ),
    );
  }
}