class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final String? difficulty;
  final String? cuisine;
  final int? caloriesPerServing;
  final List<String>? tags;
  final int userId;
  final String? image;
  final double? rating;
  final int? reviewCount;
  final List<String>? mealType;

  int get totalTimeMinutes => (prepTimeMinutes ?? 0) + (cookTimeMinutes ?? 0);

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.difficulty,
    this.cuisine,
    this.caloriesPerServing,
    this.tags,
    required this.userId,
    this.image,
    this.rating,
    this.reviewCount,
    this.mealType,
  });

  // Construtor factory para criar Recipe a partir de JSON
  // Utiliza o método _parseJsonList para garantir que os campos
  // de lista sejam tratados corretamente.
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      ingredients: _parseJsonList(json['ingredients']),
      instructions: _parseJsonList(json['instructions']),
      prepTimeMinutes: json['prep_time_minutes'] as int?,
      cookTimeMinutes: json['cook_time_minutes'] as int?,
      servings: json['servings'] as int?,
      difficulty: json['difficulty'] as String?,
      cuisine: json['cuisine'] as String?,
      caloriesPerServing: json['calories_per_serving'] as int?,
      tags: _parseJsonListOptional(json['tags']),
      userId: json['user_id'] as int,
      image: json['image'] as String?,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviewCount: json['review_count'] as int?,
      mealType: _parseJsonListOptional(json['meal_type']),
    );
  }

  // Recipe -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'prep_time_minutes': prepTimeMinutes,
      'cook_time_minutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'cuisine': cuisine,
      'calories_per_serving': caloriesPerServing,
      'tags': tags,
      'user_id': userId,
      'image': image,
      'rating': rating,
      'review_count': reviewCount,
      'meal_type': mealType,
    };
  }

  static List<String> _parseJsonList(dynamic json) {
    if (json is List) {
      return json.map((e) => e.toString()).toList();
    } else if (json is String) {
      // Quando for uma string, tenta dividir por vírgulas
      // e tratar como uma lista de strings
      try {
        final List<dynamic> parsed = json
            .split(',')
            .map((e) => e.trim())
            .toList();
        return parsed.map((e) => e.toString()).toList();
      } catch (e) {
        return [json];
      }
    }
    return [];
  }

  static List<String>? _parseJsonListOptional(dynamic json) {
    if (json == null) return null;
    return _parseJsonList(json);
  }
}
