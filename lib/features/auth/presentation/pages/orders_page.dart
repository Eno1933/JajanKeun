import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedIndex = 0;

  final List<String> tabs = ['Riwayat', 'Dalam proses', 'Terjadwal'];

  void _onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget buildOrderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.restaurant, color: Colors.red),
              Text("Rp.58.800", style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text("Ayam Benjoss, kedungkandang",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          const Text("3 item\n2 Paket Ayam Bakar Jum...", maxLines: 2),
          const SizedBox(height: 4),
          const Text("Makanan sudah diantar\n28 Des 11.36",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00AA5B)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Pesan lagi", style: TextStyle(color: Color(0xFF00AA5B))),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabContent() {
    if (selectedIndex == 0) {
      return Column(
        children: List.generate(3, (_) => buildOrderCard()),
      );
    } else {
      return const Center(child: Text("Belum ada pesanan."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Pesanan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              return GestureDetector(
                onTap: () => _onNavTap(index),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == index ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    if (selectedIndex == index)
                      Container(height: 2, width: 40, color: Colors.green),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.blue),
                  SizedBox(width: 12),
                  Text("Transaksi Gopay", style: TextStyle(fontWeight: FontWeight.w500)),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Expanded(child: SingleChildScrollView(child: buildTabContent())),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/user_dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 2:
              // stay
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        selectedItemColor: const Color(0xFF25523B),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
