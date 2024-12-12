import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/profile.jpeg'), 
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 20),
              // User Name
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              // User Email
              const Text(
                'johndoe@example.com',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              // Divider
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 20),
              // Profile Details Section
              _buildProfileDetailRow('Phone Number', '+1 123 456 7890'),
              _buildProfileDetailRow('Address', '123 Main Street, City, Country'),
              _buildProfileDetailRow('Member Since', 'January 2021'),
              const SizedBox(height: 30),
              // Action Buttons
              ElevatedButton.icon(
                onPressed: () {
                  // Add edit profile functionality
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Edit Profile', style: TextStyle(fontSize: 16,color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () {
                  // Add logout functionality
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Profile Details Row
  Widget _buildProfileDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

