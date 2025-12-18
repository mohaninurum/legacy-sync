import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/answer.dart';
import 'package:legacy_sync/features/answer/data/model/mux_response.dart';
import 'package:legacy_sync/features/answer/domain/repositories/answer_repository.dart';
import 'dart:typed_data';
import '../../../../services/notification_initialization/notification_initialization.dart';
import '../model/submit_answer_response.dart';

class AnswerRepositoryImpl implements AnswerRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<AnswerModel> getAnswers() async {
    try {
      // Using a mock endpoint for now - replace with actual API endpoint
      final res = await _apiServices.getGetApiResponse('${ApiURL.baseURL}/answers');
      return res.fold((error) => Left(error), (data) => Right(AnswerModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  @override
  ResultFuture<AnswerModel> getAnswersByQuestion(int questionId) async {
    try {
      final res = await _apiServices.getGetApiResponse('${ApiURL.baseURL}/answers/question/$questionId');
      return res.fold((error) => Left(error), (data) => Right(AnswerModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  // @override
  // Future<void> submitAnswer(int answerId, bool isSelected) async {
  //   try {
  //     final data = {'answer_id': answerId, 'is_selected': isSelected};
  //     await _apiServices.getPostApiResponse(
  //       '${ApiURL.baseURL}/answers/submit',
  //       data,
  //     );
  //   } catch (e) {
  //     throw AppException(e.toString());
  //   }
  // }

  @override
  Future<void> updateAnswerSelection(int answerId, bool isSelected) async {
    try {
      final data = {'answer_id': answerId, 'is_selected': isSelected};
      await _apiServices.getPutApiResponse('${ApiURL.baseURL}/answers/$answerId', data);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  // @override
  // ResultFuture<SubmitAnswerResponse> submitAnswer({
  //   required int qId,
  //   required int userId,
  //   required int answerType,
  //   required String answerText,
  //    File? file,
  // }) async {
  //   try {
  //     Map<String, String> data = {
  //       'question_id': '$qId',
  //       'user_id': '$userId',
  //       'answer_type': '$answerType',
  //       'answer': answerText,
  //     };
  //
  //     // For text-only answers (answerType == 1), submit without file
  //     if (answerType == 1) {
  //       final result = await _apiServices.getPostApiResponse(
  //         ApiURL.submitAnswers,
  //         data,
  //       );
  //       return result.fold(
  //         (error) => Left(AppException(error.message)),
  //         (data) => Right(SubmitAnswerResponse.fromJson(data)),
  //       );
  //     } else {
  //       // For audio/video answers, upload with file
  //
  //       final fileName = "${DateTime.now().millisecondsSinceEpoch}${file?.path.split('/').last}";
  //       Uint8List fileBytes = await file.readAsBytes();
  //       final result = await _apiServices.getPostUploadMultiPartApiResponse(
  //         ApiURL.submitAnswers,
  //         data,
  //         fileBytes,
  //         fileName,
  //         "file",
  //         "POST",
  //       );
  //       return result.fold(
  //         (error) => Left(AppException(error.message)),
  //         (data) => Right(SubmitAnswerResponse.fromJson(data)),
  //       );
  //     }
  //   } on AppException catch (e) {
  //     return Left(AppException(e.toString()));
  //   } catch (e) {
  //     return Left(AppException(e.toString()));
  //   }
  // }



  @override
  ResultFuture<SubmitAnswerResponse> submitAnswer({required int qId, required int userId, required int answerType, required String answerText, File? file}) async {
    try {
      Map<String, String> data = {'question_id': '$qId', 'user_id': '$userId', 'answer_type': '$answerType', 'answer': answerText};

      // If answerType is text OR file is null => send normal request
      if (answerType == 1 || file == null) {
        final result = await _apiServices.getPostApiResponse(ApiURL.submitAnswers, data);
        print("result:: $result");
        return result.fold((error) => Left(AppException(error.message)), (data) => Right(SubmitAnswerResponse.fromJson(data)));
      }

      // Upload multipart if file is provided
      final fileName = "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";
      Uint8List fileBytes = await file.readAsBytes();

      final result = await _apiServices.getPostUploadMultiPartApiResponse(ApiURL.submitAnswers, data, fileBytes, fileName, "file", "POST");

      return result.fold((error) => Left(AppException(error.message)), (data) => Right(SubmitAnswerResponse.fromJson(data)));
    } on AppException catch (e) {
      return Left(AppException(e.message));
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  @override
  ResultFuture<MuxResponse> getMuxUrl() async{
    try {
      final res = await _apiServices.getGetApiResponse('${ApiURL.baseURL}/legacy-modules/create-upload-mux-url');
      return res.fold((error) => Left(error), (data) => Right(MuxResponse.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }


  // @override
  // Future<bool> uploadToMux(String uploadUrl, String filePath) async {
  //   try {
  //     final dio = Dio();
  //     File file = File(filePath);
  //     final fileBytes = await file.readAsBytes();
  //
  //     final response = await dio.put(
  //       uploadUrl,
  //       data: Stream.fromIterable([fileBytes]),
  //       options: Options(
  //         headers: {
  //           "Content-Type": "video/mp4",
  //           "Content-Length": fileBytes.length,
  //         },
  //       ),
  //       onSendProgress: (sent, total) {
  //         final uploaded = "${(sent / total * 100).toStringAsFixed(2)}%";
  //         if(uploaded=="100.00%"){
  //           return true;
  //         }
  //         print("Uploaded: ${(sent / total * 100).toStringAsFixed(2)}%");
  //       },
  //     );
  //
  //     // ✅ If success: 200 or 201 response
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print("responseresponse:: ${response.statusCode} uploadUrluploadUrl $uploadUrl");
  //       return true;
  //     } else {
  //       return false;
  //     }
  //
  //   } catch (e) {
  //     print("Upload failed: $e");
  //     return false;
  //   }
  // }

  @override
  Future<bool> uploadToMux(String uploadUrl, String filePath) async {
    try {
      final dio = Dio();
      File file = File(filePath);
      final fileBytes = await file.readAsBytes();

      final completer = Completer<bool>();

      await dio.put(
        uploadUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            "Content-Type": "video/mp4",
            "Content-Length": fileBytes.length,
          },
        ),
        onSendProgress: (sent, total) {
          final percent = (sent / total * 100).toStringAsFixed(2);
          print("Uploaded: $percent%");
          if (total > 0) {
            final progress = ((sent / total) * 100).toInt();
            // showUploadProgress(progress); // 🔔 notification
          }
          if (percent == "100.00" && !completer.isCompleted) {
            completer.complete(true);
            // showUploadProgressComplete();
            // return true immediately
          }
        },
      ).then((response) {
        if (!completer.isCompleted) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            completer.complete(true);
          } else {
            completer.complete(false);
          }
        }
      }).catchError((e) {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      return completer.future;

    } catch (e) {
      print("Upload failed: $e");
      return false;
    }
  }


  @override
  ResultFuture<SubmitAnswerResponse> uploadMuxVideoAssets(Map<String, dynamic> body) async{
    try {
      final res = await _apiServices.getPostApiResponse('${ApiURL.baseURL}/legacy-modules/answers/submit-using-mux',body);
      return   res.fold((error) => Left(AppException(error.message)), (data) => Right(SubmitAnswerResponse.fromJson(data)));
    } on AppException catch (e) {
      return Left(AppException(e.message));
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }


}
