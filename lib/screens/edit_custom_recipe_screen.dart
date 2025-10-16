import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class EditCustomRecipeScreen extends StatefulWidget {
  final String username;
  final Recipe recipe;

  const EditCustomRecipeScreen({required this.username, required this.recipe, super.key});

  @override
  State<EditCustomRecipeScreen> createState() => _EditCustomRecipeScreenState();
}

class _EditCustomRecipeScreenState extends State<EditCustomRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;
  late TextEditingController _durationController;
  late TextEditingController _servingsController;

  String _selectedCategory = 'vejetaryen';
  String _selectedDifficulty = 'kolay';

  final List<String> _categories = ['vejetaryen', 'etli'];
  final List<String> _difficulties = ['kolay', 'orta', 'zor'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe.name);
    _ingredientsController = TextEditingController(text: widget.recipe.ingredients.join(', '));
    _instructionsController = TextEditingController(text: widget.recipe.instructions);
    _durationController = TextEditingController(text: widget.recipe.duration.toString());
    _servingsController = TextEditingController(text: widget.recipe.servings.toString());
    _selectedCategory = widget.recipe.category;
    _selectedDifficulty = widget.recipe.difficulty;
  }

  Future<void> _updateRecipe() async {
    if (_formKey.currentState!.validate()) {
      final boxName = 'custom_recipes_${widget.username}';
      final box = await Hive.openBox(boxName);
      final stored = box.get('recipes', defaultValue: []) as List<dynamic>;
      List<Recipe> updatedList = stored.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();

      final updatedRecipe = Recipe(
        id: widget.recipe.id,
        name: _nameController.text,
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        category: _selectedCategory,
        instructions: _instructionsController.text,
        duration: int.tryParse(_durationController.text) ?? 30,
        servings: int.tryParse(_servingsController.text) ?? 2,
        difficulty: _selectedDifficulty,
      );

      final index = updatedList.indexWhere((r) => r.id == widget.recipe.id);
      if (index != -1) {
        updatedList[index] = updatedRecipe;
        await box.put('recipes', updatedList.map((r) => r.toJson()).toList());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarif güncellendi')),
      );

      Navigator.pop(context, true);
    }
  }

  Future<void> _addToUserMenu() async {
    final menuBoxName = 'menu_${widget.username}';
    final menuBox = await Hive.openBox(menuBoxName);
    final storedMenu = menuBox.get('menu', defaultValue: []) as List<dynamic>;
    List<Recipe> menuList = storedMenu.map((e) => Recipe.fromJson(Map<String, dynamic>.from(e))).toList();

    if (!menuList.any((r) => r.id == widget.recipe.id)) {
      menuList.add(widget.recipe);
      await menuBox.put('menu', menuList.map((r) => r.toJson()).toList());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarif menüye eklendi')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bu tarif zaten menüde var.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifi Düzenle'),
        backgroundColor: const Color(0xFF4C9F70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tarif Adı'),
                validator: (value) => value == null || value.isEmpty ? 'Lütfen tarif adı girin' : null,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Malzemeler (virgülle ayır)'),
                validator: (value) => value == null || value.isEmpty ? 'Malzemeleri girin' : null,
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'Hazırlık Talimatı'),
                validator: (value) => value == null || value.isEmpty ? 'Hazırlık bilgisi girin' : null,
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Hazırlık Süresi (dk)'),
              ),
              TextFormField(
                controller: _servingsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Porsiyon Sayısı'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Zorluk'),
                items: _difficulties.map((dif) => DropdownMenuItem(value: dif, child: Text(dif))).toList(),
                onChanged: (value) => setState(() => _selectedDifficulty = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateRecipe,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C9F70)),
                child: const Text('Güncelle'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addToUserMenu,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Menüye Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}