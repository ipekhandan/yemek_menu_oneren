import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class AddCustomRecipeScreen extends StatefulWidget {
  final String username;
  const AddCustomRecipeScreen({required this.username, super.key});

  @override
  State<AddCustomRecipeScreen> createState() => _AddCustomRecipeScreenState();
}

class _AddCustomRecipeScreenState extends State<AddCustomRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  String _selectedCategory = 'vejetaryen';
  String _selectedDifficulty = 'kolay';

  final List<String> _categories = ['vejetaryen', 'etli'];
  final List<String> _difficulties = ['kolay', 'orta', 'zor'];

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final customBoxName = 'custom_recipes_${widget.username}';
      final customBox = await Hive.openBox(customBoxName);

      final newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        category: _selectedCategory,
        instructions: _instructionsController.text,
        duration: int.tryParse(_durationController.text) ?? 30,
        servings: int.tryParse(_servingsController.text) ?? 2,
        difficulty: _selectedDifficulty,
      );

      final storedRecipes = customBox.get('recipes', defaultValue: []) as List<dynamic>;
      storedRecipes.add(newRecipe.toJson());
      await customBox.put('recipes', storedRecipes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarif başarıyla eklendi!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kendi Tarifini Ekle'),
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
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C9F70)),
                child: const Text('Tarifi Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
