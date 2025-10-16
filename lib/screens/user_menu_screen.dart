import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class UserMenuScreen extends StatefulWidget {
  final String username;
  const UserMenuScreen({required this.username, super.key});

  @override
  State<UserMenuScreen> createState() => _UserMenuScreenState();
}

class _UserMenuScreenState extends State<UserMenuScreen> {
  late Box menuBox;
  List<Recipe> userMenu = [];

  @override
  void initState() {
    super.initState();
    _loadUserMenu();
  }

  Future<void> _loadUserMenu() async {
    final boxName = 'menu_${widget.username}';
    menuBox = await Hive.openBox(boxName);
    final storedMenus = menuBox.get('menu', defaultValue: []) as List<dynamic>;

    setState(() {
      userMenu = storedMenus.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
    });
  }

  Future<void> _removeFromMenu(Recipe recipe) async {
    setState(() {
      userMenu.removeWhere((r) => r.id == recipe.id);
    });
    await menuBox.put('menu', userMenu.map((r) => r.toJson()).toList());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarif menüden çıkarıldı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Menü'),
        backgroundColor: const Color(0xFF4C9F70),
      ),
      body: userMenu.isEmpty
          ? const Center(child: Text('Menünüzde henüz tarif yok.'))
          : ListView.builder(
        itemCount: userMenu.length,
        itemBuilder: (context, index) {
          final recipe = userMenu[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(recipe.name),
              subtitle: Text(
                '⏱ ${recipe.duration} dk | 🍽 ${recipe.servings} kişilik | 📊 ${recipe.difficulty}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromMenu(recipe),
              ),
            ),
          );
        },
      ),
    );
  }
}