import 'package:cloud_firestore/cloud_firestore.dart';

enum FoodCategory { burgers, salads, sides, desserts, drinks }

class Addon {
  final String name;
  final String description;
  final double price;

  Addon({required this.name, required this.description, required this.price});

  factory Addon.fromMap(Map<String, dynamic> data) {
    return Addon(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

class Food {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final FoodCategory category;
  final List<Addon> availableAddons;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.availableAddons,
  });

  factory Food.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num).toDouble(),
      category: FoodCategory.values.firstWhere(
        (e) => e.toString() == 'FoodCategory.${data['category']}',
        orElse: () => FoodCategory.burgers,
      ),
      availableAddons: data['availableAddons'] != null
          ? (data['availableAddons'] as List)
              .map((addonData) => Addon.fromMap(addonData))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category.toString().split('.').last,
      'availableAddons': availableAddons.map((a) => a.toMap()).toList(),
    };
  }
}
