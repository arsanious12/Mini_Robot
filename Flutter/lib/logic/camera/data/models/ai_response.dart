class AiResponse {
  final String? userName;
  final String status;

  AiResponse({this.userName, required this.status});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      userName: json['name'], 
      status: json['status'],
    );
  }
}
