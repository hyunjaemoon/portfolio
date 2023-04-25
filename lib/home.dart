import 'package:flutter/material.dart';

class PortfolioHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hyun Jae Moon'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Hyun Jae Moon',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Software Engineer & Mobile App Developer',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Welcome to my portfolio app! I am an experienced software engineer with a passion for creating visually appealing and user-friendly applications. Please feel free to browse my projects and contact me for any inquiries.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
              ),
              child: Text('Contact Me'),
            ),
          ],
        ),
      ),
    );
  }
}
