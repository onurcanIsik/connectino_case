class UserModel {
  String? userMail;
  String? userId;
  String? userName;
  String? userPhotoUrl;
  String? userPassword;

  UserModel({
    this.userMail,
    this.userId,
    this.userName,
    this.userPhotoUrl,
    this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userMail': userMail,
      'userId': userId,
      'userName': userName ?? '',
      'userPhotoUrl': userPhotoUrl ?? '',
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userMail: json['userMail'],
      userId: json['userId'],
      userName: json['userName'],
      userPhotoUrl: json['userPhotoUrl'],
      userPassword: json['userPassword'],
    );
  }
}
