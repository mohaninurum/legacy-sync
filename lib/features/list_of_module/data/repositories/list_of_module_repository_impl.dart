import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/submit_answer_response.dart';
import 'package:legacy_sync/features/list_of_module/data/model/delete_answer_model.dart';
import 'package:legacy_sync/features/list_of_module/data/model/list_of_module_model.dart';
import 'package:legacy_sync/features/list_of_module/data/model/module_answer_model.dart';
import 'package:legacy_sync/features/list_of_module/domain/repositories/list_of_module_repository.dart';

import '../../../../config/db/shared_preferences.dart';

class ListOfModuleRepositoryImpl implements ListOfModuleRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<ListOfModuleModel> getListOfModule(int moduleID, int userID) async {
    try {
      final res = await _apiServices.getGetApiResponse("${ApiURL.legacy_module}$moduleID?user_id=$userID");
      AppPreference().set(key: "SUBMITTED", value: "false");
      return res.fold((error) => Left(error), (data) => Right(ListOfModuleModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<void> updateGoalSelection(int goalId, bool isSelected) {
    // TODO: implement updateGoalSelection
    throw UnimplementedError();
  }

  @override
  ResultFuture<ModuleAnswerModel> getAnswerOfModule(Map<String,dynamic> body) async{
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.module_answers,body);
      return res.fold((error) => Left(error), (data) => Right(ModuleAnswerModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<DeleteAnswerModel> deleteAnswerOfModule(int answerId) async{
    try {
      final res = await _apiServices.getDeleteApiResponse("${ApiURL.delete_answers}$answerId",{});
      return res.fold((error) => Left(error), (data) => Right(DeleteAnswerModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<SubmitAnswerResponse> submitAnswer({required int qId, required int userId, required int answerType, required String answerText, File? file}) async {
    try {
      Map<String, String> data = {'question_id': '$qId', 'user_id': '$userId', 'answer_type': '$answerType', 'answer': answerText};

      // If answerType is text OR file is null => send normal request
      if (answerType == 1 || file == null) {
        final result = await _apiServices.getPostApiResponse(ApiURL.submitAnswers, data);
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
}
