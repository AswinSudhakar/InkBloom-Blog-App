class UserProfileModel {
  String? name;
  String? email;
  String? createdAt;
  String? profileImage;
  List<String>? selectedCategories; // Changed from Null to String
  List<String>? favourites; // Changed from Null to String

  UserProfileModel({
    this.name,
    this.email,
    this.createdAt,
    this.profileImage,
    this.selectedCategories,
    this.favourites,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      profileImage: json['profile_image'],
      selectedCategories: json['selected_categories'] != null
          ? List<String>.from(json['selected_categories'])
          : [], // Convert dynamic list to List<String>
      favourites: json['favourites'] != null
          ? List<String>.from(json['favourites'])
          : [], // Convert dynamic list to List<String>
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'created_at': createdAt,
      'profile_image': profileImage,
      'selected_categories': selectedCategories ?? [],
      'favourites': favourites ?? [],
    };
  }
}
