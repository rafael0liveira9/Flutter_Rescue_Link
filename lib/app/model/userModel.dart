class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  int? type;
  int? situation;
  String? jobStateType;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.type,
    this.situation,
    this.jobStateType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      type: map['type'],
      situation: map['situation'],
      jobStateType: map['jobStateType'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type,
      'situation': situation,
      'jobStateType': jobStateType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, type: $type, situation: $situation, jobStateType: $jobStateType, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
