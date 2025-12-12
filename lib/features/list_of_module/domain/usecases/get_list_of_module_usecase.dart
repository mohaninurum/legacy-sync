import 'dart:io';

import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/submit_answer_response.dart';
import 'package:legacy_sync/features/list_of_module/data/model/list_of_module_model.dart';
import 'package:legacy_sync/features/list_of_module/data/model/module_answer_model.dart';
import 'package:legacy_sync/features/list_of_module/data/repositories/list_of_module_repository_impl.dart';
import 'package:legacy_sync/features/list_of_module/domain/repositories/list_of_module_repository.dart';

import '../../data/model/delete_answer_model.dart';

class GetListOfModuleUsecase {
  final ListOfModuleRepository repository = ListOfModuleRepositoryImpl();
  ResultFuture<ListOfModuleModel> getListOfModules({required int moduleID, required int userID}) async {
    return await repository.getListOfModule(moduleID,userID);
  }

  ResultFuture<ModuleAnswerModel> getAnswerOfModule({required Map<String,dynamic> body}) async {
    return await repository.getAnswerOfModule(body);
  }


  ResultFuture<DeleteAnswerModel> deleteAnswerOfModule({required int answerId}) async {
    return await repository.deleteAnswerOfModule(answerId);
  }
  ResultFuture<SubmitAnswerResponse> submitAnswer({required int qId,required int userId,required int answerType,required String answerText, File? file}) async {
    return await repository.submitAnswer(answerText:answerText ,answerType: answerType,file:file ,qId: qId,userId: userId);
  }
}
