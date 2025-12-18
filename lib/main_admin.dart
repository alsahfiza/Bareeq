import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:Bareeq/firebase_options.dart';

import 'package:Bareeq/admin/core/view_models/auth_provider.dart';
import 'package:Bareeq/admin/core/view_models/products_provider.dart';
import 'package:Bareeq/admin/core/view_models/orders_provider.dart';
import 'package:Bareeq/admin/core/view_models/search_provider.dart';
import 'package:Bareeq/admin/core/view_models/picture_provider.dart';
import 'package:Bareeq/admin/core/view_models/update_image_provider.dart';
import 'package:Bareeq/admin/core/view_models/user_data_provider.dart';
import 'package:Bareeq/admin/core/view_models/theme_change_provider.dart';
import 'package:Bareeq/admin/core/view_models/product_upload_image_provider.dart';
import 'package:Bareeq/admin/ui/constants/theme_data.dart';
import 'package:Bareeq/admin/ui/routes/route_name.dart';
import 'package:Bareeq/admin/ui/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔒 WEB SAFE DEFAULT
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductsProvider()),
            ChangeNotifierProvider(create: (_) => PicturesProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ImageListProductUpload()),
            ChangeNotifierProvider(create: (_) => UpdateImageProvider()),
            ChangeNotifierProvider(create: (_) => UserDataProvider()),
            ChangeNotifierProvider(create: (_) => OrdersProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(
              create: (_) => ThemeChangeProvider(false),
            ),
          ],
          child: Consumer<ThemeChangeProvider>(
            builder: (_, themeChangeProvider, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Bareeq Admin',
                theme: Styles.getThemeData(
                  themeChangeProvider.isDarkTheme,
                ),
                initialRoute: RouteName.mainScreen,
                onGenerateRoute: Routes.generatedRoute,
              );
            },
          ),
        );
      },
    );
  }
}
