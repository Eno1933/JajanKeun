import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final List<String> canteens = [
    "Kantin 1",
    "Kantin 2",
    "Kantin 3",
    "Kantin 4",
    "Kantin 5",
    "Kantin 6",
  ];

  String userName = '';

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
    });
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'notifikasi':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur Notifikasi belum tersedia')),
        );
        break;
      case 'pengaturan':
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Halo, $userName",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onSelected: _onMenuSelected,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'notifikasi',
                      child: Text('Notifikasi'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'pengaturan',
                      child: Text('Pengaturan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF25523B),
                                Color.fromARGB(255, 146, 177, 157),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        canteens[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "We are here with the best food",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white70),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              const Color(0xFF25523B),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text("Kunjungi"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  'assets/images/canteen.png',
                                  width: 80,
                                  height: 60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: canteens.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF25523B),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
