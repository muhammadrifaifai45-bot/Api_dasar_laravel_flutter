class loginResponse{
bool succes;
String message;
String token;

loginResponse({
  required this.succes,
  required this.message,
  required this.token,
});
factory loginResponse.fromJson(Map<String,dynamic>json){
  return loginResponse(
    succes: json["succes"],
    message: json["message"],
    token: json["token"]
  );  
}

}