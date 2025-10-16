import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RandomMenuScreen extends StatefulWidget {
  final String username;

  const RandomMenuScreen({required this.username, super.key});

  @override
  State<RandomMenuScreen> createState() => _RandomMenuScreenState();
}

class _RandomMenuScreenState extends State<RandomMenuScreen> {
  List<Recipe> allRecipes = [];
  List<Recipe> selectedRecipes = [];
  List<Recipe> userMenu = [];
  List<Recipe> favoriteRecipes = [];
  late Box menuBox;
  late Box favoritesBox;

  String selectedCategory = 'Hepsi';
  final List<String> categories = ['Hepsi', 'vejetaryen', 'etli'];

  @override
  void initState() {
    super.initState();
    allRecipes = RecipeService.getAllRecipes();
    _openUserBoxes();
  }

  Future<void> _openUserBoxes() async {
    final menuBoxName = 'menu_${widget.username}';
    final favoritesBoxName = 'favorites_${widget.username}';

    menuBox = await Hive.openBox(menuBoxName);
    favoritesBox = await Hive.openBox(favoritesBoxName);

    final storedMenus = menuBox.get('menu', defaultValue: []) as List<dynamic>;
    final storedFavorites = favoritesBox.get('favorites', defaultValue: []) as List<dynamic>;

    setState(() {
      userMenu = storedMenus.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
      favoriteRecipes = storedFavorites.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
    });

    _generateRandomMenu();
  }

  void _generateRandomMenu() {
    final filteredRecipes = selectedCategory == 'Hepsi'
        ? allRecipes
        : allRecipes.where((r) => r.category == selectedCategory).toList();

    final random = Random();
    final shuffled = List<Recipe>.from(filteredRecipes)..shuffle(random);

    setState(() {
      selectedRecipes = shuffled.take(2).toList();
    });
  }

  void _addToUserMenu(Recipe recipe) {
    if (!userMenu.any((r) => r.id == recipe.id)) {
      setState(() {
        userMenu.add(recipe);
      });
      _saveMenuToHive();
    }
  }

  void _removeFromUserMenu(Recipe recipe) {
    setState(() {
      userMenu.removeWhere((r) => r.id == recipe.id);
    });
    _saveMenuToHive();
  }

  void _saveMenuToHive() {
    final jsonList = userMenu.map((r) => r.toJson()).toList();
    menuBox.put('menu', jsonList);
  }

  void _saveFavoritesToHive() {
    final jsonList = favoriteRecipes.map((r) => r.toJson()).toList();
    favoritesBox.put('favorites', jsonList);
  }

  void _addToFavorites(Recipe recipe) {
    if (!favoriteRecipes.any((r) => r.id == recipe.id)) {
      setState(() {
        favoriteRecipes.add(recipe);
      });
      _saveFavoritesToHive();
    }
  }

  bool _isFavorite(Recipe recipe) {
    return favoriteRecipes.any((r) => r.id == recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70),
        title: const Text('Otomatik Menü Önerisi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat.toUpperCase()),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCategory = value);
                  _generateRandomMenu();
                }
              },
            ),
            ElevatedButton(
              onPressed: _generateRandomMenu,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9F70),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text('Yeni Menü Öner', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = selectedRecipes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipe.instructions, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                            '⏱ ${recipe.duration} dk   🍽 ${recipe.servings} kişilik   📊 ${recipe.difficulty}',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addToUserMenu(recipe),
                          ),
                          IconButton(
                            icon: Icon(
                              _isFavorite(recipe) ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite(recipe) ? Colors.red : null,
                            ),
                            onPressed: () => _addToFavorites(recipe),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text('📋 Günlük Menü (${userMenu.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: userMenu.length,
                itemBuilder: (context, index) {
                  final item = userMenu[index];
                  return ListTile(
                    title: Text(item.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFromUserMenu(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
