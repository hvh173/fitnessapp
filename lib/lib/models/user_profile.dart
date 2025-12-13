class UserProfile {
final String uid;
final String displayName;
final String email;
final int age;
final double weight;


UserProfile({
required this.uid,
required this.displayName,
required this.email,
required this.age,
required this.weight,
});


Map<String, dynamic> toJson() => {
'uid': uid,
'displayName': displayName,
'email': email,
'age': age,
'weight': weight,
};


factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
uid: json['uid'],
displayName: json['displayName'],
email: json['email'],
age: json['age'],
weight: (json['weight'] as num).toDouble(),
);
}