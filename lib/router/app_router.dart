import 'package:go_router/go_router.dart';

/* -------------------------
   CUSTOMER PAGES
-------------------------- */
import '../pages/home_page.dart';
import '../pages/products_page.dart';
import '../pages/category_page.dart';
import '../pages/cart_page.dart';
import '../pages/checkout_page.dart';
import '../pages/order_success_page.dart';
import '../pages/search_page.dart';
import '../pages/contact_page.dart';
import '../pages/about_page.dart';

/* -------------------------
   ADMIN PAGES
-------------------------- */
import '../admin/auth/admin_login_page.dart';
import '../admin/auth/auth_gate.dart';

import '../admin/layout/admin_layout.dart';
import '../admin/dashboard/admin_dashboard_page.dart';

import '../admin/products/admin_products_page.dart';
import '../admin/products/admin_add_products_page.dart';
import '../admin/products/edit_product_page.dart';

import '../admin/categories/admin_categories_page.dart';
import '../admin/categories/admin_add_category_page.dart';
import '../admin/categories/edit_category_page.dart';

import '../admin/orders/admin_orders_page.dart';
import '../admin/orders/admin_order_details_page.dart';
import '../admin/settings/admin_settings_page.dart';


class AppRouter {
  /* -------------------------------------------------------------------
      CUSTOMER WEBSITE ROUTER
     ------------------------------------------------------------------- */
  static final GoRouter customerRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomePage(),
      ),

      GoRoute(
        path: '/products/:id',
        builder: (_, state) =>
            ProductPage(productId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: '/category/:id',
        builder: (_, state) =>
            CategoryPage(categoryId: state.pathParameters['id']!),
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
        builder: (_, state) =>
            OrderSuccessPage(orderId: state.pathParameters['orderId']!),
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
    ],
  );

  /* -------------------------------------------------------------------
      ADMIN PANEL ROUTER
     ------------------------------------------------------------------- */
  static final GoRouter adminRouter = GoRouter(
    initialLocation: '/admin/login',
    routes: [
      // LOGIN PAGE (no layout)
      GoRoute(
        path: '/admin/login',
        builder: (_, __) => const AdminLoginPage(),
      ),

      // EVERYTHING AFTER LOGIN USES THE ADMIN LAYOUT
      ShellRoute(
        builder: (_, __, child) => AdminLayout(child: child),

        routes: [
          /* ------------------ DASHBOARD ------------------ */
          GoRoute(
            path: '/admin/dashboard',
            builder: (_, __) => AdminAuthGate(
              child: const AdminDashboardPage(),
            ),
          ),
          /* ------------------ SETTINGS ------------------ */
          GoRoute(
            path: '/admin/settings',
            builder: (_, __) => AdminAuthGate(
              child: const AdminSettingsPage()
              ),
            ),
          /* ------------------ PRODUCTS ------------------ */
          GoRoute(
            path: '/admin/products',
            builder: (_, __) => AdminAuthGate(
              child: const AdminProductsPage(),
            ),
          ),

          GoRoute(
            path: '/admin/products/add',
            builder: (_, __) => AdminAuthGate(
              child: const AdminAddProductsPage(),
            ),
          ),

          GoRoute(
            path: '/admin/products/edit/:id',
            builder: (_, state) => AdminAuthGate(
              child: EditProductPage(
                productId: state.pathParameters['id']!,
              ),
            ),
          ),

          /* ------------------ CATEGORIES ------------------ */
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
            builder: (_, state) => AdminAuthGate(
              child: EditCategoryPage(
                categoryId: state.pathParameters['id']!,
              ),
            ),
          ),

          /* ------------------ ORDERS ------------------ */
          GoRoute(
            path: '/admin/orders',
            builder: (_, __) => AdminAuthGate(
              child: const AdminOrdersPage(),
            ),
          ),
          
          GoRoute(
            path: '/admin/orders/:id',
            builder: (_, state) => AdminAuthGate(
              child: AdminOrderDetailsPage(
                orderId: state.pathParameters['id']!,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
