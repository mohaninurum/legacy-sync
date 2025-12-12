// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings_error.dart';
import 'package:legacy_sync/features/auth/domain/usecases/auth_usecase.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordState());
  bool _isFormValid = false;

  AuthUseCase authUseCase = AuthUseCase();
  void resetState() {
    emit(const ResetPasswordState());
  }

  Future<void> checkFormValidation({required String email}) async {
    if (email.isEmpty || !email.isEmail) {
      _isFormValid = false;
      emit(
        const ResetPasswordState(error: AppStringsError.pleaseEnterValidEmail),
      );
      return;
    }
    _isFormValid = true;
    emit(const ResetPasswordState(isFormValid: true));
  }

  void sendOtpOnEmail({required String email}) async{
    try{
      Map<String, dynamic> body = {"email": email};
      emit(state.copyWith(isLoading: true, error: null,otpSendSuccess: false));
      var sendOtpOnEmail = await authUseCase.sendOtpOnEmail(body: body);
      emit(state.copyWith(isLoading: false));
      sendOtpOnEmail.fold(
            (failure) {
          emit(state.copyWith(error: (failure.errorCode??0)==404?"User dose not exist on legacy. You can registered your self": failure.message ?? "Something went wrong please try again later in some time"));
        }, (data) {
        emit(state.copyWith(otpSendSuccess:true));
      },
      );
    }catch(e){
      debugPrint("ErrorCatch Send Otp $e");
      emit(state.copyWith(isLoading: false, error: null,otpSendSuccess: false));
    }


  }


}
