import "dart:convert";
import "dart:math" as math;
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import 'recipe_detail.dart';

// --- Model Class ---
// We add idMeal to capture the unique ID for each recipe.
class RecipeModel {
  String idMeal;
  String applabel;
  String appimgurl;
  String appcalories;

  RecipeModel({
    required this.idMeal,
    required this.applabel,
    required this.appimgurl,
    required this.appcalories,
  });

  // The factory now extracts the idMeal from the API response.
  factory RecipeModel.fromMap(Map<String, dynamic> json) {
    return RecipeModel(
      idMeal: json["idMeal"] ?? "",
      applabel: json["strMeal"] ?? "Unknown",
      appimgurl: json["strMealThumb"] ?? "",
      appcalories: "N/A",
    );
  }
}

// --- Home Widget ---
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipelist = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  Future<void> getRecipe(String query) async {
    setState(() {
      isLoading = true;
      recipelist.clear();
    });

    String url =
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$query";

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data["meals"] != null) {
          data["meals"].forEach((element) {
            RecipeModel recipemodel = RecipeModel.fromMap(element);
            recipelist.add(recipemodel);
          });
        }
      }
    } catch (e) {
      print("Error fetching recipes: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipe("chicken"); // default search
  }

  @override
  Widget build(BuildContext context) {
    var suggestions = ["Chicken", "Paneer", "Rice", "Soup"];
    final _random = math.Random();
    var randomSuggestion = suggestions[_random.nextInt(suggestions.length)];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).trim().isEmpty) {
                          print("Blank Search");
                        } else {
                          getRecipe(searchController.text.trim());
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(2, 0, 7, 0),
                        child: Icon(Icons.search),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search $randomSuggestion",
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            getRecipe(value.trim());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Header Text
              Container(
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      "What Would You Like to Cook Today?",
                      style:
                      TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Let's Cook Something!",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              // Recipe List
              isLoading
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : recipelist.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "No recipes found!",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recipelist.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetail(recipe: recipelist[index]),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              recipelist[index].appimgurl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                recipelist[index].applabel,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                recipelist[index].appcalories,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

