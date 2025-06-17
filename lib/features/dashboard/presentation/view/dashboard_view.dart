import 'package:flutter/material.dart';
import 'package:rolo/features/bottom_navigation/presentation/view/bottom_navigation_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> bagItems = [
      {'title': 'Rolo Laptop Bag', 'image': 'assets/images/rolo_laptop_bag.jpeg'},
      {'title': 'Rolo Backpacks', 'image': 'assets/images/rolo_black_bag.png'},
      {'title': 'Rolo Hand Bags', 'image': 'assets/images/rolo_light_bag.png'},
      {'title': 'Rolo College Bags', 'image': 'assets/images/rolo_red_bag.png'},
      {'title': 'Rolo Chest Bag', 'image': 'assets/images/rolo_gateway_bag.jpeg'},
      {'title': 'Rolo Crossbody Bag', 'image': 'assets/images/rolo_tote_bag.jpeg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/user_logo.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[850],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: 'Search for luxury items...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Explore the ROLO Collection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.amber,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: bagItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bagItems[index]['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Shop Now"),
                              ),
                            ],
                          ),
                        ),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            bagItems[index]['image']!,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationView(
        currentIndex: 0,
        onTap: (index) {
        },
      ),
    );
  }
}