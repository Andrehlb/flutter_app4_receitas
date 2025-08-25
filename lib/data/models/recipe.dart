class Recipe { // Modelo de Receita
  final String id; // UUID do Supabase tratado como String
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
  final String userId; // Também UUID (profiles.id/auth.users.id)
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

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      ingredients: _parseJsonList(json['ingredients']),
      instructions: _parseJsonList(json['instructions']),
      prepTimeMinutes: json['prep_time_minutes'] is int
          ? json['prep_time_minutes'] as int
          : int.tryParse(json['prep_time_minutes']?.toString() ?? ''),
      cookTimeMinutes: json['cook_time_minutes'] is int
          ? json['cook_time_minutes'] as int
          : int.tryParse(json['cook_time_minutes']?.toString() ?? ''),
      servings: json['servings'] is int
          ? json['servings'] as int
          : int.tryParse(json['servings']?.toString() ?? ''),
      difficulty: json['difficulty']?.toString(),
      cuisine: json['cuisine']?.toString(),
      caloriesPerServing: json['calories_per_serving'] is int
          ? json['calories_per_serving'] as int
          : int.tryParse(json['calories_per_serving']?.toString() ?? ''),
      tags: _parseJsonListOptional(json['tags']),
      userId: json['user_id']?.toString() ?? '',
      image: json['image']?.toString(),
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? ''),
      reviewCount: json['review_count'] is int
          ? json['review_count'] as int
          : int.tryParse(json['review_count']?.toString() ?? ''),
      mealType: _parseJsonListOptional(json['meal_type']),
    );
  }

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
      try {
        final List<dynamic> parsed =
            json.split(',').map((e) => e.trim()).toList();
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