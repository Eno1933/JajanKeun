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
  String userPhoto = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
      userPhoto = prefs.getString('photo') ?? '';
    });
  }

  Future<void> _openProfile() async {
    final result = await Navigator.pushNamed(context, '/profile');
    if (result != null) {
      await loadUserData(); // refresh data tanpa bergantung pada true/false
    }
  }

  void _onMenuSelected(String value) {
    if (value == 'notifikasi') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur Notifikasi belum tersedia')),
      );
    } else if (value == 'pengaturan') {
      Navigator.pushNamed(context, '/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _openProfile,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: userPhoto.isNotEmpty
                        ? NetworkImage('http://192.168.12.44/jajankeun_api/uploads/profile/$userPhoto')
                        : const AssetImage('assets/images/user.png') as ImageProvider,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Halo, $userName",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onSelected: _onMenuSelected,
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'notifikasi', child: Text('Notifikasi')),
                    PopupMenuItem(value: 'pengaturan', child: Text('Pengaturan')),
                  ],
                ),
              ],
            ),
          ),

          // List
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
                    (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF25523B), Color(0xFF92B19D)],
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        canteens[i],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "We are here with the best food",
                                        style: GoogleFonts.poppins(color: Colors.white70),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF25523B),
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text("Kunjungi"),
                                      )
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF25523B),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
          else if(index == 2) {
            Navigator.pushNamed(context, '/orders');
          }
          // handle other tabs...
        },
        type: BottomNavigationBarType.fixed,
        items: const [
         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
