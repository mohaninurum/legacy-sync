import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/answer/data/model/answer.dart';
import 'package:legacy_sync/features/answer/domain/repositories/answer_repository.dart';

class GetAnswersUseCase {
  final AnswerRepository repository;

  GetAnswersUseCase(this.repository);

  ResultFuture<AnswerModel> call() async {
    return await repository.getAnswers();
  }
}
