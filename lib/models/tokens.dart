class Tokens {
  final String accessToken;
  Tokens({this.accessToken});
  factory Tokens.fromJson(Map<String, dynamic> m) {
    return Tokens(accessToken: m['accessToken']);
  }
}