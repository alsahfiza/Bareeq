import '../models/cart_item_model.dart';

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
  }

  void increase(String id) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index >= 0) _items[index].quantity++;
  }

  void decrease(String id) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index >= 0 && _items[index].quantity > 1) {
      _items[index].quantity--;
    }
  }

  void clear() {
    _items.clear();
  }
}
