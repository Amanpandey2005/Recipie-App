import  'package:flutter/material.dart';
import 'model.dart'; // Import your RecipeModel

class RecipeDetail extends StatelessWidget {
  final RecipeModel recipe;

  // Constructor to receive the recipe data
  const RecipeDetail({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar shows the recipe name
      appBar: AppBar(
        title: Text(recipe.applabel),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView( // Allows the content to be scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recipe Image
            Image.network(
              recipe.appimgurl,
              height: 250,
              fit: BoxFit.cover,
              // Show a placeholder while loading or if an error occurs
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 250,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600])),
                );
              },
            ),

            // Recipe Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title
                  Text(
                    recipe.applabel,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Calories Information
                  Text(
                    "Calories: ${recipe.appcalories}",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Placeholder for Ingredients
                  Text(
                    "Ingredients",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                  SizedBox(height: 8),
                  // This is a placeholder. You would need to add ingredients to your model.
                  Text(
                    "This section will show the list of ingredients needed for the recipe. You'll need to update your RecipeModel to include an ingredients list from your API data.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),

                  SizedBox(height: 24),

                  // Placeholder for a URL link
                  Text(
                    "Full Recipe",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                  SizedBox(height: 8),
                  // This is a placeholder. You would need to add ingredients to your model.
                  Text(
                    "This section could have a button to view the full recipe on its original website. You would need to add the recipe URL to your RecipeModel.",
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
