// In your home.dart file

class RecipeModel {
  String idMeal; // <-- ADD THIS
  String applabel;
  String appimgurl;
  String appcalories;

  RecipeModel({
    required this.idMeal, // <-- ADD THIS
    required this.applabel,
    required this.appimgurl,
    required this.appcalories,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> json) {
    return RecipeModel(
      idMeal: json["idMeal"] ?? "", // <-- ADD THIS
      applabel: json["strMeal"] ?? "Unknown",
      appimgurl: json["strMealThumb"] ?? "",
      appcalories: "N/A",
    );
  }
}