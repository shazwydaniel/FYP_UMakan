class Vendor {
  final String id;
  final String vendorName;
  final String vendorEmail;
  final String contactInfo;
  final String role;
  final String password; // Add this field to match your controller

  Vendor({
    required this.id,
    required this.vendorName,
    required this.vendorEmail,
    required this.contactInfo,
    required this.role,
    required this.password, // Initialize it here
  });

  // Static Function to Create an Empty User Model
  static Vendor empty() => Vendor(
        id: '',
        vendorName: '',
        vendorEmail: '',
        contactInfo: '',
        password: '',
        role: '',
      );

  factory Vendor.fromMap(Map<String, dynamic> map, String id) {
    return Vendor(
      id: map['id'],
      vendorName: map['vendorName'],
      contactInfo: map['contactInfo'],
      vendorEmail: map['vendorEmail'],
      role: map['role'],
      password: map['password'], // Extract it from the map
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Vendor Name': vendorName,
      'Contact Info': contactInfo,
      'Vendor Email': vendorEmail,
      'Role': role,
      'Password': password, // Include it in the JSON
    };
  }
}
