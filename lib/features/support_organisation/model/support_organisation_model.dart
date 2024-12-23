class SupportOrganisationModel {
  final String id;
  final String organisationName;
  final String email;
  final String contactNumber;
  final String profilePicture;
  final String location;
  final String activeStatus;
  final String role;

  SupportOrganisationModel({
    required this.id,
    required this.organisationName,
    required this.email,
    required this.contactNumber,
    this.profilePicture = 'assets/images/default_profile_icon.png',
    required this.location,
    required this.activeStatus,
    this.role = 'Support Organisation',
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Organisation Name': organisationName,
      'Email': email,
      'Contact Number': contactNumber,
      'Profile Picture': profilePicture,
      'Location': location,
      'Active Status': activeStatus,
      'Role': role,
    };
  }

  // Convert from Map
  factory SupportOrganisationModel.fromMap(String id, Map<String, dynamic> map) {
    return SupportOrganisationModel(
      id: id,
      organisationName: map['Organisation Name'] ?? '',
      email: map['Email'] ?? '',
      contactNumber: map['Contact Number'] ?? '',
      profilePicture: map['Profile Picture'] ?? 'assets/images/default_profile_icon.png',
      location: map['Location'] ?? '',
      activeStatus: map['Active Status'] ?? 'Active',
      role: map['Role'] ?? 'Support Organisation',
    );
  }

  // Add a copyWith method
  SupportOrganisationModel copyWith({
    String? id,
    String? organisationName,
    String? email,
    String? contactNumber,
    String? profilePicture,
    String? location,
    String? activeStatus,
    String? role,
  }) {
    return SupportOrganisationModel(
      id: id ?? this.id,
      organisationName: organisationName ?? this.organisationName,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      location: location ?? this.location,
      activeStatus: activeStatus ?? this.activeStatus,
      role: role ?? this.role,
    );
  }
}