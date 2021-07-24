class User {
  String? _nameUser;
  String? _firstNameUser;
  String? _loginUser;
  String? _mdpUser;

  String? get nameUser => _nameUser;
  String? get firstNameUser => _firstNameUser;
  String? get loginUser => _loginUser;
  String? get mdpUser => _mdpUser;

  User({
      String? nameUser, 
      String? firstNameUser, 
      String? loginUser, 
      String? mdpUser}){
    _nameUser = nameUser;
    _firstNameUser = firstNameUser;
    _loginUser = loginUser;
    _mdpUser = mdpUser;
}

  User.fromJson(dynamic json) {
    _nameUser = json["name_user"];
    _firstNameUser = json["first_name_user"];
    _loginUser = json["login_user"];
    _mdpUser = json["mdp_user"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name_user"] = _nameUser;
    map["first_name_user"] = _firstNameUser;
    map["login_user"] = _loginUser;
    map["mdp_user"] = _mdpUser;
    return map;
  }

}