import 'dart:io';

import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/answer/domain/repositories/answer_repository.dart';

class SubmitAnswerUseCase {
  final AnswerRepository repository;

  SubmitAnswerUseCase(this.repository);

  ResultFuture<dynamic> submitAnswer({required int qId,required int userId,required int answerType,required String answerText,required File file}) async {
    return await repository.submitAnswer(answerText:answerText ,answerType: answerType,file:file ,qId: qId,userId: userId);
  }
}
