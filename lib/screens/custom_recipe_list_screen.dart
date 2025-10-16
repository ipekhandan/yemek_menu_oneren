import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';
import 'edit_custom_recipe_screen.dart';

class CustomRecipeListScreen extends StatefulWidget {
  final String username;
  const CustomRecipeListScreen({required this.username, super.key});

  @override
  State<CustomRecipeListScreen> createState() => _CustomRecipeListScreenState();
}

class _CustomRecipeListScreenState extends State<CustomRecipeListScreen> {
  late Box customBox;
  List<Recipe> customRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final boxName = 'custom_recipes_${widget.username}';
    customBox = await Hive.openBox(boxName);
    final stored = customBox.get('recipes', defaultValue: []) as List<dynamic>;

    setState(() {
      customRecipes = stored.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();
    });
  }

  Future<void> _deleteRecipe(int id) async {
    customRecipes.removeWhere((r) => r.id == id);
    final jsonList = customRecipes.map((r) => r.toJson()).toList();
    await customBox.put('recipes', jsonList);
    setState(() {});
  }

  void _editRecipe(Recipe recipe) {
    // Gelecekte düzenleme formu eklemek için kullanılabilir.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Düzenleme özelliği yakında eklenecek.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eklediğim Tarifler'),
        backgroundColor: const Color(0xFF4C9F70),
      ),
      body: customRecipes.isEmpty
          ? const Center(child: Text('Henüz tarif eklemediniz.'))
          : ListView.builder(
        itemCount: customRecipes.length,
        itemBuilder: (context, index) {
          final recipe = customRecipes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(recipe.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⏱ ${recipe.duration} dk | 🍽 ${recipe.servings} kişilik | 📊 ${recipe.difficulty}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    recipe.instructions,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCustomRecipeScreen(
                            username: widget.username,
                            recipe: recipe,
                          ),
                        ),
                      );
                      if (updated == true) _loadRecipes(); // listeyi güncelle
                    },

                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteRecipe(recipe.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
