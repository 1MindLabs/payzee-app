class CitizenSignup {
  String name;
  String password;
  String aadharNumber;

  CitizenSignup({
    required this.name,
    required this.password,
    required this.aadharNumber,
  });

  // Convert a CitizenSignup object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'id_number': aadharNumber,
    };
  }

  // Create a CitizenSignup object from a JSON map
  factory CitizenSignup.fromJson(Map<String, dynamic> json) {
    return CitizenSignup(
      name: json['name'],
      password: json['password'],
      aadharNumber: json['id_number'],
    );
  }
}
