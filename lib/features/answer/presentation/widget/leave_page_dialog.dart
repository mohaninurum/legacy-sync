import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/comman_components/custom_button.dart';
import '../bloc/answer_bloc/answer_cubit.dart';
import '../bloc/answer_state/answer_state.dart';




// Function to show alert dialog
Future<bool?> showLeavePageDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => BlocProvider(
      create: (context) => AnswerCubit(),
      child: BlocListener<AnswerCubit, AnswerState>(
        listener: (context, state) {
          if (state.leavePageDialogState == LeavePageDialogState.confirmed) {
            Navigator.of(context).pop(true);
          } else if (state.leavePageDialogState == LeavePageDialogState.cancelled) {
            Navigator.of(context).pop(false);
          }
        },
        child: AlertDialog(
          backgroundColor: const Color(0xFF2D1B69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'You really want to leave this page?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<AnswerCubit, AnswerState>(
                      builder: (context, state) {
                        return TextButton(
                          onPressed: () {
                            context.read<AnswerCubit>().cancelLeave();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Decline',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 24,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BlocBuilder<AnswerCubit, AnswerState>(
                      builder: (context, state) {
                        return TextButton(
                          onPressed: () {
                            context.read<AnswerCubit>().confirmLeave();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Leave',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

