import 'dart:io';

import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/submit_answer_response.dart';
import 'package:legacy_sync/features/list_of_module/data/model/list_of_module_model.dart';

import '../../data/model/delete_answer_model.dart';
import '../../data/model/module_answer_model.dart';

abstract class ListOfModuleRepository {
  ResultFuture<ListOfModuleModel> getListOfModule(int moduleId,int userID);
  ResultFuture<ModuleAnswerModel> getAnswerOfModule(Map<String,dynamic> body);
  ResultFuture<DeleteAnswerModel> deleteAnswerOfModule(int answerId);
  Future<void> updateGoalSelection(int goalId, bool isSelected);
  ResultFuture<SubmitAnswerResponse> submitAnswer({required int qId,required int userId,required int answerType,required String answerText, File? file});

}
