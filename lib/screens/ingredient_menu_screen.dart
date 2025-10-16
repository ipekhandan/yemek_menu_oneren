// lib/screens/ingredient_menu_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class IngredientMenuScreen extends StatefulWidget {
  final String username;
  const IngredientMenuScreen({required this.username, super.key});

  @override
  State<IngredientMenuScreen> createState() => _IngredientMenuScreenState();
}

class _IngredientMenuScreenState extends State<IngredientMenuScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  List<String> userIngredients = [];
  List<Recipe> matchedRecipes = [];
  List<Recipe> userMenu = [];
  List<Recipe> favoriteRecipes = [];
  String selectedCategory = 'Hepsi';
  final List<String> categories = ['Hepsi', 'vejetaryen', 'etli'];
  late Box menuBox;
  late Box favoritesBox;

  @override
  void initState() {
    super.initState();
    _openHiveBoxes();
  }

  Future<void> _openHiveBoxes() async {
    menuBox = await Hive.openBox('menu_${widget.username}');
    favoritesBox = await Hive.openBox('favorites_${widget.username}');

    final storedMenu = menuBox.get('menu', defaultValue: []) as List<dynamic>;
    final storedFavorites = favoritesBox.get('favorites', defaultValue: []) as List<dynamic>;

    setState(() {
      userMenu = storedMenu.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
      favoriteRecipes = storedFavorites.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
    });
  }

  void _addIngredient() {
    final text = _ingredientController.text.trim().toLowerCase();
    if (text.isNotEmpty && !userIngredients.contains(text)) {
      setState(() {
        userIngredients.add(text);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String item) {
    setState(() {
      userIngredients.remove(item);
    });
  }

  void _findMatchingRecipes() {
    final allRecipes = RecipeService.getAllRecipes();

    final matches = allRecipes.where((recipe) {
      final recipeIngredients = recipe.ingredients.map((e) => e.toLowerCase()).toList();
      final matchCount = userIngredients.where((ingredient) => recipeIngredients.contains(ingredient)).length;
      return matchCount >= recipeIngredients.length - 1; // en fazla 1 eksik malzeme
    }).where((recipe) =>
    selectedCategory == 'Hepsi' || recipe.category == selectedCategory
    ).toList();

    setState(() {
      matchedRecipes = matches;
    });
  }

  void _addToMenu(Recipe recipe) {
    if (!userMenu.any((r) => r.id == recipe.id)) {
      setState(() => userMenu.add(recipe));
      final jsonList = userMenu.map((r) => r.toJson()).toList();
      menuBox.put('menu', jsonList);
    }
  }

  void _addToFavorites(Recipe recipe) {
    if (!favoriteRecipes.any((r) => r.id == recipe.id)) {
      setState(() => favoriteRecipes.add(recipe));
      final jsonList = favoriteRecipes.map((r) => r.toJson()).toList();
      favoritesBox.put('favorites', jsonList);
    }
  }

  void _openRecipeDetails(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recipe.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: ${recipe.category}'),
            const SizedBox(height: 10),
            Text('Malzemeler:'),
            ...recipe.ingredients.map((e) => Text('- $e')),
            const SizedBox(height: 10),
            Text('Tarif: ${recipe.instructions}')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70),
        title: const Text('Malzemeye Göre Menü Öner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: const InputDecoration(
                      labelText: 'Malzeme gir (ör: yumurta)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addIngredient,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C9F70)),
                  child: const Text('Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat.toUpperCase()))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCategory = value);
                }
              },
            ),
            Wrap(
              spacing: 8,
              children: userIngredients.map((item) => Chip(label: Text(item), onDeleted: () => _removeIngredient(item))).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _findMatchingRecipes,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C9F70)),
              child: const Text('Tarifleri Göster'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: matchedRecipes.isEmpty
                  ? const Text('Eşleşen tarif bulunamadı.')
                  : ListView.builder(
                itemCount: matchedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = matchedRecipes[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text(recipe.instructions, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addToMenu(recipe),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () => _addToFavorites(recipe),
                          ),
                        ],
                      ),
                    )

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