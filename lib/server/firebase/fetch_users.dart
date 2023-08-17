import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String username;
  String role;
  List<String> permissions;
  // Add other fields as necessary

  User({required this.email, required this.username, required this.role, required this.permissions});

  factory User.fromFirestore(Map<String, dynamic> firestoreData, String email) {
    List<String> permissionsList = List<String>.from(firestoreData['permissions']);
    return User(
      email: email,
      username: firestoreData['username'],
      role: firestoreData['role'],
      permissions: permissionsList,
    );
  }
}

Future<List<User>> fetchEmployees() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await _firestore
      .collection('users')
      .where('role', isEqualTo: 'employee')
      .get();

  final List<User> employees = snapshot.docs
      .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
      .toList();

  return employees;
}