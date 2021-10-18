class UserLogin {
  String email;
  String password;
  UserLogin(this.email, this.password);
}

class UserRegister {
  // authorities: ["ROLE_STUDENT"]
  // email: "123@gmail.com"
  // langKey: "en"
  // login: "Mahir09"
  // password: "1234"
  var authorities;
  String email;
  String lanKey;
  String login;
  String password;
  UserRegister(
      this.email, this.password, this.authorities, this.lanKey, this.login);
}

class User {
  int id;
  String login;
  String firstName;
  String lastName;
  String email;
  bool activated;
  String langKey;
  String authorities;
  String createdBy;
  DateTime reatedDate;
  String lastModifiedBy;
  DateTime lastModifiedDate;

  User({
    this.id,
    this.login,
    this.firstName,
    this.lastName,
    this.email,
    this.activated,
    this.langKey,
    this.authorities,
    this.createdBy,
    this.reatedDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });
}

// class User implements IUser {
//   // User({int id,
//   // String login,
//   // String lastName,
//   // String email,
//   // bool activated,
//   // String langKey,
//   // String authorities,
//   // String createdBy,
//   // DateTime reatedDate,
//   // String lastModifiedBy,
//   // DateTime lastModifiedDate,});
//
//   @override
//   bool activated;
//
//   @override
//   String authorities;
//
//   @override
//   String createdBy;
//
//   @override
//   String email;
//
//   @override
//   String firstName;
//
//   @override
//   int id;
//
//   @override
//   String langKey;
//
//   @override
//   String lastModifiedBy;
//
//   @override
//   DateTime lastModifiedDate;
//
//   @override
//   String lastName;
//
//   @override
//   String login;
//
//   @override
//   DateTime reatedDate;
// }
