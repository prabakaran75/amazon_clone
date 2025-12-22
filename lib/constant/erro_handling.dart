import 'dart:convert';
import 'package:http/http.dart' as http;

String? errorHandling(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return null; // success (no error)
    case 400:
      return jsonDecode(response.body)['msg'];
    case 500:
      return jsonDecode(response.body)['error'];
    default:
      return response.body;
  }
}

// void errorHandling({
//   required http.Response response,
//   required BuildContext context,
//   required VoidCallback onSuccess,
// }) {
//   switch (response.statusCode) {
//     case 200:
//       onSuccess();
//       break;
//     case 400:
//       showSnackBar(context, jsonDecode(response.body)['msg']);
//       break;
//     case 500:
//       showSnackBar(context, jsonDecode(response.body)['error']);
//       break;
//     default:
//       showSnackBar(context, response.body);
//   }
// }
