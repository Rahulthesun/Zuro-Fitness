class Gym {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int credits;
  final List<String> categories;
  final String imageUrl;

  Gym({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.credits,
    required this.categories,
    this.imageUrl = '',
  });
}