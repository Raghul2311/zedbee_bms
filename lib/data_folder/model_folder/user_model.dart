class UserModel {
  final bool login;
  final String message;
  final String city;
  final String custDomainKey;
  final String mobile;
  final String country;
  final String firstName;
  final String lastName;
  final String email;
  final String custId;
  final String sessionToken;
  final String role;
  final List<String> buildingIds;

  UserModel({
    required this.login,
    required this.message,
    required this.city,
    required this.custDomainKey,
    required this.mobile,
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.custId,
    required this.email,
    required this.sessionToken,
    required this.role,
    required this.buildingIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final session = json['session_obj'] as Map<String, dynamic>? ?? {};

    String parsedRole = "";

    // Admin role field
    if (session['roles'] is List && session['roles'].isNotEmpty) {
      parsedRole = session['roles'][0].toString();
    }

    // App user role field
    if (session['role'] is List && session['role'].isNotEmpty) {
      parsedRole = session['role'][0].toString();
    }

    // Parse building IDs safely
    List<String> parsedBuildingIds = [];

    if (session['building_id'] is List) {
      parsedBuildingIds = List<String>.from(
        session['building_id'].map((e) => e.toString()),
      );
    }

    return UserModel(
      login: json['login'] ?? false,
      message: json['message'] ?? '',
      city: session['city'] ?? '',
      custDomainKey: session['cust_domainkey'] ?? '',
      mobile: session['mobile'] ?? '',
      country: session['country'] ?? '',
      firstName: session['first_name'] ?? '',
      lastName: session['last_name'] ?? '',
      email: session['email'] ?? '',
      custId: session['cust_id'] ?? '',
      sessionToken: session['sessionToken'] ?? '',
      role: parsedRole,
      buildingIds: parsedBuildingIds,
    );
  }
}
