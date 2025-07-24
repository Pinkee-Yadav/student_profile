class Student {
  String fullName;
  String email;
  String contactNumber;
  DateTime dateOfBirth;
  String gender;
  String? profileImagePath;

  Student({
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.dateOfBirth,
    required this.gender,
    this.profileImagePath,
  });
}
