import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class FavoritesScreen extends StatefulWidget {
  final String username;
  const FavoritesScreen({required this.username, super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recipe> favorites = [];
  late Box favoritesBox;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoritesBox = await Hive.openBox('favorites_${widget.username}');
    final stored = favoritesBox.get('favorites', defaultValue: []) as List<dynamic>;
    setState(() {
      favorites = stored.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
    });
  }

  void _removeFromFavorites(Recipe recipe) {
    setState(() {
      favorites.removeWhere((r) => r.id == recipe.id);
    });
    final jsonList = favorites.map((r) => r.toJson()).toList();
    favoritesBox.put('favorites', jsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70),
        title: const Text('Favori Tarifler'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Henüz favori tarifiniz yok.'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final recipe = favorites[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(recipe.name),
              subtitle: Text(recipe.instructions, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeFromFavorites(recipe),
              ),
            ),
          );
        },
      ),
    );
  }
}
