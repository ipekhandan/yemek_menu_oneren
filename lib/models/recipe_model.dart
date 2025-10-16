class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final String category;
  final String instructions;

  final int duration;       // ⏱ Hazırlama süresi (dk)
  final int servings;       // 🍽 Porsiyon sayısı
  final String difficulty;  // 📊 Zorluk derecesi

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.category,
    required this.instructions,
    required this.duration,
    required this.servings,
    required this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      category: json['category'],
      instructions: json['instructions'],
      duration: json['duration'],
      servings: json['servings'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'category': category,
      'instructions': instructions,
      'duration': duration,
      'servings': servings,
      'difficulty': difficulty,
    };
  }
}
