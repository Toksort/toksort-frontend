// import 'package:dio/dio.dart';

// class UserService {
//   static Future<Either<ExceptionResponse, BaseResponse<UserProfileModel>>>
//       getProfile() async {
//     return await ApiClient.instance.request(
//       HttpMethod.get,
//       path: ApiEndpoint.getUser,
//       dio: DioClient.instance.initInstance(),
//       headers: await HeaderClient.setHeaderBearer(),
//       responseConverter: (body) {
//         final nestedData = body['data'];
//         final userJson = nestedData is Map<String, dynamic>
//             ? (nestedData['data'] ?? nestedData)
//             : {};
//         return BaseResponse<UserProfileModel>.fromJson(
//           body,
//           (json) => UserProfileModel.fromJson(userJson),
//         );
//       },
//     );
//   }

//   static Future<Either<ExceptionResponse, RoleResponse>> getRole() async {
//     return await ApiClient.instance.request(
//       HttpMethod.get,
//       path: ApiEndpoint.getRole,
//       dio: DioClient.instance.initInstance(),
//       headers: await HeaderClient.setHeaderBearer(),
//       responseConverter: (body) {
//         return RoleResponse.fromJson(body);
//       },
//     );
//   }

//   static Future<Either<ExceptionResponse, UpdateProfileModel>> putProfile({
//     required UpdateProfileModel request,
//   }) async {
//     return await ApiClient.instance.request(
//       HttpMethod.put,
//       path: ApiEndpoint.putProfileUser,
//       dio: DioClient.instance.initInstance(),
//       headers: await HeaderClient.setHeaderBearer(),
//       body: request.toJson(), // jangan lupa kirim body
//       responseConverter: (body) {
//         return UpdateProfileModel.fromJson(body);
//       },
//     );
//   }

//   static Future<Either<ExceptionResponse, String>> uploadAvatar({
//     required String filePath,
//   }) async {
//     final headers = await HeaderClient.setHeaderBearerMultipart();

//     final formData = dio.FormData();
//     formData.files.add(
//       MapEntry(
//         'avatar',
//         await dio.MultipartFile.fromFile(
//           filePath,
//           filename: filePath.split('/').last,
//         ),
//       ),
//     );

//     return await ApiClient.instance.request(
//       HttpMethod.put,
//       path: ApiEndpoint.putProfileUser, // endpoint update foto profil
//       dio: DioClient.instance.initInstance(),
//       headers: headers,
//       body: formData,
//       responseConverter: (body) {
//         // server balikin URL avatar
//         return body['data']['url'] as String;
//       },
//     );
//   }
// }
