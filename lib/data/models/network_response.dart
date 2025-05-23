class NetworkResponse {
  final bool isSucsess;
  final int statusCode;
  dynamic responseData;
  String errorMessage;

  NetworkResponse(
      {required this.isSucsess,
      required this.statusCode,
      this.responseData,
      this.errorMessage = 'Something went wrong'});
}
