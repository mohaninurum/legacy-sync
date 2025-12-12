import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/answer.dart';
import 'package:legacy_sync/features/answer/domain/repositories/answer_repository.dart';

class GetAnswersByQuestionUseCase {
  final AnswerRepository repository;

  GetAnswersByQuestionUseCase(this.repository);

  ResultFuture<AnswerModel> call(int questionId) async {
    return await repository.getAnswersByQuestion(questionId);
  }
}
