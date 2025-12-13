import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../services/cart_sync_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  CartProvider() {
    loadCart();
  }

  List<CartItem> get items => _items;

  // -----------------------------
  // LOAD CART FROM LOCAL STORAGE
  // -----------------------------
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart');

    if (data != null) {
      final List decoded = jsonDecode(data);

      _items.clear();
      for (var item in decoded) {
        _items.add(
          CartItem(
            id: item["id"],
            nameAr: item["nameAr"],
            imageUrl: item["imageUrl"],
            price: item["price"].toDouble(),
            quantity: item["quantity"],
          ),
        );
      }
    }

    // Try loading cloud version (if logged in)
    final cloudItems = await CartSyncService.loadCartFromFirestore();
    if (cloudItems.isNotEmpty) {
      _items
        ..clear()
        ..addAll(cloudItems);
    }

    notifyListeners();
  }

  // -----------------------------
  // SAVE CART LOCALLY
  // -----------------------------
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = _items.map((e) {
      return {
        "id": e.id,
        "nameAr": e.nameAr,
        "imageUrl": e.imageUrl,
        "price": e.price,
        "quantity": e.quantity,
      };
    }).toList();

    prefs.setString("cart", jsonEncode(jsonList));

    // Also sync to Firestore
    await CartSyncService.syncCartToFirestore(_items);
  }

  // -----------------------------
  // ADD ITEM
  // -----------------------------
  void addItem(CartItem item) {
    int index = _items.indexWhere((i) => i.id == item.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }

    saveCart();
    notifyListeners();
  }

  // -----------------------------
  // REMOVE ITEM
  // -----------------------------
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    saveCart();
    notifyListeners();
  }

  // -----------------------------
  // INCREASE QTY
  // -----------------------------
  void increaseQty(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    item.quantity++;
    saveCart();
    notifyListeners();
  }

  // -----------------------------
  // DECREASE QTY
  // -----------------------------
  void decreaseQty(String id) {
    final item = _items.firstWhere((i) => i.id == id);

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      removeItem(id);
      return;
    }

    saveCart();
    notifyListeners();
  }

  // -----------------------------
  // TOTAL
  // -----------------------------
  double get total {
    double t = 0;
    for (var item in _items) {
      t += item.price * item.quantity;
    }
    return t;
  }

  // -----------------------------
  // CLEAR CART
  // -----------------------------
  void clear() {
    _items.clear();
    saveCart();
    notifyListeners();
  }
}
