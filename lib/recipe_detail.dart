import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class RecipeDetail extends StatefulWidget {
  final RecipeModel recipe;
  const RecipeDetail({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  String instructions = "Loading instructions...";
  // 1. Create a list to hold the ingredients
  List<String> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    String url =
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.recipe.idMeal}";
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["meals"] != null && data["meals"].isNotEmpty) {
          var mealData = data["meals"][0];
          List<String> fetchedIngredients = [];

          // 2. The API has up to 20 ingredients. We loop through them.
          for (int i = 1; i <= 20; i++) {
            final ingredient = mealData['strIngredient$i'];
            final measure = mealData['strMeasure$i'];

            // If the ingredient is not null and not empty, add it to our list
            if (ingredient != null && ingredient.trim().isNotEmpty) {
              fetchedIngredients.add("$measure $ingredient");
            }
          }

          // 3. Update the state with the new data
          setState(() {
            instructions =
                mealData["strInstructions"] ?? "No instructions found.";
            ingredients = fetchedIngredients;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching recipe details: $e");
      setState(() {
        instructions = "Failed to load instructions.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.applabel),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.recipe.appimgurl,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey[600])),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.applabel,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),

                  // 4. New section to display the ingredients
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Display each ingredient using a bullet point
                  for (String ingredient in ingredients)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ", style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 24),

                  Text(
                    "Instructions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    instructions,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}