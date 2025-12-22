// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;

// Future<String?> updateImageToCloudinary(File imageFile) async {
//   String cloudName = "dxddklc4a";
//   String presetName = "se7ety";

//   final url = Uri.parse(
//     "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
//   );

//   final request = http.MultipartRequest('post', url);

//   request.fields['upload_preset'] = presetName;

//   request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//   try {
//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final responseData = json.decode(responseBody);

//       return responseData['secure_url'];
//     } else {
//       print('Failed to upload image. Status code: ${response.statusCode}');
//       final errorBody = await response.stream.bytesToString();
//       print('Error response body: $errorBody');
//       return null;
//     }
//   } catch (e) {
//     print('Exception caught while uploading image: $e');
//     return null;
//   }
// }
