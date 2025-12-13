import 'dart:io';

import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/answer.dart';
import 'package:legacy_sync/features/answer/data/model/mux_response.dart';
import 'package:legacy_sync/features/answer/data/model/submit_answer_response.dart' show SubmitAnswerResponse;
import 'package:legacy_sync/features/answer/data/repositories/answer_repository_impl.dart';
import '../repositories/answer_repository.dart';

class AnswerUseCase {
  final AnswerRepository repository = AnswerRepositoryImpl();


  ResultFuture<SubmitAnswerResponse> submitAnswer({required int qId,required int userId,required int answerType,required String answerText, File? file}) async {
    return await repository.submitAnswer(answerText:answerText ,answerType: answerType,file:file ,qId: qId,userId: userId);
  }
  ResultFuture<MuxResponse> getMuxUrl() async {
    return await repository.getMuxUrl();
  }
  Future<bool> uploadToMux(String uploadUrl, String filePath) async {
    return await repository.uploadToMux(uploadUrl, filePath);
  }

  ResultFuture<SubmitAnswerResponse> uploadMuxVideoAssets(Map<String,dynamic> body) async {
    return await repository.uploadMuxVideoAssets(body);
  }
}