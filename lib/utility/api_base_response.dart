class ApiBaseResponse {
  int? statusCode;
  String? message;
  String? exceptionMessage;
  dynamic data;

  ApiBaseResponse({
    this.statusCode,
    this.message,
    this.exceptionMessage,
    this.data,
  });

  ApiBaseResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    message = json['Message'];
    exceptionMessage = json['ExceptionMessage'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['Message'] = message;
    data['ExceptionMessage'] = exceptionMessage;
    data['Data'] = data;
    return data;
  }
}
