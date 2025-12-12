import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/question/data/model/question.dart';
import 'package:legacy_sync/features/question/data/model/survey_questions_submit_response.dart';
import 'package:legacy_sync/features/question/domain/repositories/question_repository.dart';

class QuestionImplRepo implements QuestionRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<QueationModel> getQuestions() async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiURL.survey);
      return res.fold(
        (error) => Left(error),
        (data) => Right(QueationModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<SurveyQuestionsSubmitResponse> submitSurveyQuestions(Map<String, dynamic> payload) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.submit_survey, payload);
      return res.fold(
        (error) => Left(error),
        (data) => Right(SurveyQuestionsSubmitResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }

  }
}
