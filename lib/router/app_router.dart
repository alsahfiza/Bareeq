import 'package:go_router/go_router.dart';

/* ---------------------- Public Pages ---------------------- */
import '../pages/home_page.dart';
import '../pages/products_page.dart';
import '../pages/category_products_page.dart';
import '../pages/cart_page.dart';
import '../pages/checkout_page.dart';
import '../pages/order_success_page.dart';
import '../pages/search_page.dart';
import '../pages/contact_page.dart';
import '../pages/about_page.dart';

/* ---------------------- Admin Pages ---------------------- */
import '../admin/auth/admin_login_page.dart';
import '../admin/auth/auth_gate.dart';
import '../admin/layout/admin_layout.dart';

import '../admin/dashboard/admin_dashboard_page.dart';

import '../admin/products/admin_products_page.dart';
import '../admin/products/admin_add_product_page.dart';
import '../admin/products/edit_product_page.dart';

import '../admin/categories/admin_categories_page.dart';
import '../admin/categories/admin_add_category_page.dart';
import '../admin/categories/edit_category_page.dart';

import '../admin/orders/admin_orders_page.dart';
import '../admin/orders/admin_order_details_page.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [

      /* -----------------------------------------------------------
      |                      PUBLIC ROUTES                         |
      ------------------------------------------------------------ */

      GoRoute(
        path: '/',
        builder: (_, __) => const HomePage(),
      ),

      GoRoute(
        path: '/products/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return ProductPage(productId: id);
        },
      ),

      GoRoute(
        path: '/category/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return CategoryProductsPage(categoryId: id);
        },
      ),

      GoRoute(
        path: '/cart',
        builder: (_, __) => const CartPage(),
      ),

      GoRoute(
        path: '/checkout',
        builder: (_, __) => const CheckoutPage(),
      ),

      GoRoute(
        path: '/order-success/:orderId',
        builder: (_, state) {
          final orderId = state.pathParameters['orderId']!;
          return OrderSuccessPage(orderId: orderId);
        },
      ),

      GoRoute(
        path: '/search',
        builder: (_, __) => const SearchPage(),
      ),

      GoRoute(
        path: '/contact',
        builder: (_, __) => const ContactPage(),
      ),

      GoRoute(
        path: '/about',
        builder: (_, __) => const AboutPage(),
      ),


      /* -----------------------------------------------------------
      |                       ADMIN ROUTES                          |
      ------------------------------------------------------------ */

      GoRoute(
        path: '/admin/login',
        builder: (_, __) => const AdminLoginPage(),
      ),

      // ADMIN AREA PROTECTED BY AUTH GATE + ADMIN LAYOUT
      ShellRoute(
        builder: (_, __, child) => AdminLayout(child: child),

        routes: [

          GoRoute(
            path: '/admin',
            builder: (_, __) => AdminAuthGate(
              child: const AdminDashboardPage(),
            ),
          ),

          GoRoute(
            path: '/admin/products',
            builder: (_, __) => AdminAuthGate(
              child: const AdminProductsPage(),
            ),
          ),

          GoRoute(
            path: '/admin/products/add',
            builder: (_, __) => AdminAuthGate(
              child: const AdminAddProductPage(),
            ),
          ),

          GoRoute(
            path: '/admin/products/edit/:id',
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return AdminAuthGate(
                child: EditProductPage(productId: id),
              );
            },
          ),

          GoRoute(
            path: '/admin/categories',
            builder: (_, __) => AdminAuthGate(
              child: const AdminCategoriesPage(),
            ),
          ),

          GoRoute(
            path: '/admin/categories/add',
            builder: (_, __) => AdminAuthGate(
              child: const AddCategoryPage(),
            ),
          ),

          GoRoute(
            path: '/admin/categories/edit/:id',
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return AdminAuthGate(
                child: EditCategoryPage(categoryId: id),
              );
            },
          ),

          GoRoute(
            path: '/admin/orders',
            builder: (_, __) => AdminAuthGate(
              child: const AdminOrdersPage(),
            ),
          ),
          GoRoute(
            path: '/admin/orders/:id',
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return AdminAuthGate(
                child: AdminOrderDetailsPage(orderId: id),
              );
            },
          ),

        ],
      ),
    ],
  );
}
