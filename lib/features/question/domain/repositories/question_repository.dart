import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/question/data/model/question.dart';

import '../../data/model/survey_questions_submit_response.dart';

abstract class QuestionRepository {
  ResultFuture<QueationModel> getQuestions();
  ResultFuture<SurveyQuestionsSubmitResponse> submitSurveyQuestions(Map<String, dynamic> payload);
}
