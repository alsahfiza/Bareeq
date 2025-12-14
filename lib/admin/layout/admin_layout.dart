import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      body: Row(
        children: [
          // -------------------------
          //     LEFT SIDEBAR
          // -------------------------
          const SizedBox(
            width: 240,
            child: AdminSidebar(),
          ),

          // -------------------------
          //       MAIN CONTENT
          // -------------------------
          Expanded(
            child: Column(
              children: [
                // -------------------------
                //      TOP APP BAR
                // -------------------------
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "BAREEQ Admin Panel",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings_outlined),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // -------------------------
                //         PAGE CONTENT
                // -------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
