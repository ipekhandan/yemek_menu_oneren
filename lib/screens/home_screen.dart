import 'package:flutter/material.dart';
import 'ingredient_menu_screen.dart';
import 'random_menu_screen.dart';
import 'favorites_screen.dart';
import 'add_custom_recipe_screen.dart';
import 'custom_recipe_list_screen.dart';
import 'user_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70),
        title: Text('Hoş geldin, $username 👋'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(username: username),
                ),
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Menü nasıl oluşturulsun?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // 🍽️ Otomatik Menü
            MenuOptionButton(
              title: '🍽️ Otomatik Menü Öner',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RandomMenuScreen(username: username),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🥕 Elimdeki Malzemelerle Menü
            MenuOptionButton(
              title: '🥕 Elimdeki Malzemelere Göre Menü Öner',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IngredientMenuScreen(username: username),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            MenuOptionButton(
              title: '👨‍🍳 Kendi Tarifini Ekle',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCustomRecipeScreen(username: username),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            MenuOptionButton(
              title: '📒 Eklediğim Tarifler',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomRecipeListScreen(username: username),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            MenuOptionButton(
              title: '📋 Günlük Menüm',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserMenuScreen(username: username),
                  ),
                );
              },
            ),



          ],
        ),
      ),
    );
  }
}

class MenuOptionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MenuOptionButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C9F70),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
