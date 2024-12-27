class AppUserConfiguration {
  // String userId;
  String enterpriseId;

  AppUserConfiguration({
    // this.userId,
    required this.enterpriseId,
  });

  factory AppUserConfiguration.fromJson(Map<String, dynamic> json) {
    return AppUserConfiguration(
      // userId = json['user_id'],
      enterpriseId: json['enterprise_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'user_id': userId,
      'enterprise_id': enterpriseId,
    };
  }
}
