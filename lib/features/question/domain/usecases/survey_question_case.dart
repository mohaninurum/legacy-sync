import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/question/data/model/question.dart';
import 'package:legacy_sync/features/question/data/model/survey_questions_submit_response.dart';
import 'package:legacy_sync/features/question/domain/repositories/question_repository.dart';

import '../../data/repositories/question_impl_repo.dart';

class GetQuestionCase {
  final QuestionRepository repository =  QuestionImplRepo();

  ResultFuture<QueationModel> getQuestions() {
    return repository.getQuestions();
  }

  ResultFuture<SurveyQuestionsSubmitResponse> submitSurvey(Map<String,dynamic> payload) {
    return repository.submitSurveyQuestions(payload);
  }
}
