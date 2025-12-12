import 'dart:io';

import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/answer.dart';
import 'package:legacy_sync/features/answer/data/model/mux_response.dart';
import 'package:legacy_sync/features/answer/data/model/submit_answer_response.dart';

abstract class AnswerRepository {
  ResultFuture<AnswerModel> getAnswers();
  ResultFuture<MuxResponse> getMuxUrl();
  ResultFuture<AnswerModel> getAnswersByQuestion(int questionId);
  ResultFuture<SubmitAnswerResponse> submitAnswer({required int qId,required int userId,required int answerType,required String answerText, File? file});
  Future<void> updateAnswerSelection(int answerId, bool isSelected);
  Future<bool> uploadToMux(String uploadUrl, String filePath);
  Future<bool> uploadMuxVideoAssets(Map<String,dynamic> body);
}
