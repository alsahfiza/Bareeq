import 'package:flutter/material.dart';
// import '../dashboard/admin_dashboard_page.dart';
// import '../categories/admin_categories_page.dart';
// import '../categories/admin_add_category_page.dart';
// import '../products/admin_products_page.dart';
// import '../products/admin_add_product_page.dart';
// import '../auth/admin_login_page.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  const AdminLayout({super.key, required this.child});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  // FIXED: dynamic instead of Object
  List<Map<String, dynamic>> get menuItems => [
        {
          "label": "لوحة التحكم",
          "route": "/admin",
          "icon": Icons.dashboard,
        },
        {
          "label": "المنتجات",
          "route": "/admin/products",
          "icon": Icons.shopping_bag,
        },
        {
          "label": "إضافة منتج",
          "route": "/admin/products/add",
          "icon": Icons.add_box,
        },
        {
          "label": "الأقسام",
          "route": "/admin/categories",
          "icon": Icons.category,
        },
        {
          "label": "إضافة قسم",
          "route": "/admin/categories/add",
          "icon": Icons.add_circle,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Row(
        children: [
          // SIDE MENU
          Container(
            width: 250,
            color: Colors.teal[700],
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "لوحة الإدارة",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                const SizedBox(height: 30),

                // MENU LIST
                ...List.generate(menuItems.length, (index) {
                  return ListTile(
                    leading: Icon(
                      menuItems[index]["icon"],
                      color: Colors.white,
                    ),
                    title: Text(
                      menuItems[index]["label"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, menuItems[index]["route"]);
                    },
                  );
                }),

                const Spacer(),

                // LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("تسجيل الخروج",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/admin/login");
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: widget.child,
            ),
          )
        ],
      ),
    );
  }
}
