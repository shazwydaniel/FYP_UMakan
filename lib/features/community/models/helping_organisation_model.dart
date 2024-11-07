class HelpingOrganisation {
  final String id;
  final String name;
  final String contact;
  final String location;
  final String imagePath;

  HelpingOrganisation({
    required this.id,
    required this.name,
    required this.contact,
    required this.location,
    required this.imagePath,
  });

  factory HelpingOrganisation.fromMap(String id, Map<String, dynamic> data) {
    return HelpingOrganisation(
      id: id,
      name: data['name'] ?? '',
      contact: data['contact'] ?? '',
      location: data['location'] ?? '',
      imagePath: data['imagePath'] ?? '',
    );
  }
}
