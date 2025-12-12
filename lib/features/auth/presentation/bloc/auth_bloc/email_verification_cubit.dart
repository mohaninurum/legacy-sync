import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/auth/domain/usecases/auth_usecase.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/verification_code_state.dart';

class EmailVerificationCubit extends Cubit<VerificationCodeState> {
  EmailVerificationCubit() : super( VerificationCodeState());
  AuthUseCase authUseCase = AuthUseCase();
  Timer? _timer;
  void resetState() {
    _timer?.cancel();
    emit( VerificationCodeState());
  }


  void checkOTPFilled(String pin) {
    final isValid = pin.length == 6;
    if (state.buttonIsEnable != isValid) {
      emit(state.copyWith(buttonIsEnable: isValid));
    }
  }

  void checkOTPIsValid({required String email,required String pin}) async {
    try{
      Map<String, dynamic> body = {"email": email,"otp":pin};
      emit(state.copyWith(loading: true));
      var otpModel = await authUseCase.emailVerification(body: body);
      emit(state.copyWith(loading: false));
      otpModel.fold(
            (failure) {
          emit(OTPEnvalidState());
          emit(state.copyWith(error: (failure.errorCode??0)==404?"User dose not exist on legacy. You can registered your self": failure.message ?? "Something went wrong please try again later in some time"));
        }, (data) {
        emit(OTPValidState());
      },
      );
    }catch(e){
      debugPrint("ErrorCatch Send Otp $e");
      emit(state.copyWith(loading: false));
      emit(OTPEnvalidState());
    }

  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
