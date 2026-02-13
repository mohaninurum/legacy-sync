import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/images/images.dart';

extension LKExampleExt on BuildContext {
  //

  Future<bool?> showUnsavedPodcastDialog() => showDialog<bool>(
    context: this,
    barrierDismissible: false,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Unsaved podcast'),
          content: const Text(
            'Your recording hasn’t been saved yet. If you go back now, you may lose your changes. Do you want to leave anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Leave'),
            ),
          ],
        ),
  );

  Future<bool?> showPublishDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Publish'),
          content: const Text('Would you like to publish your Camera & Mic ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('YES'),
            ),
          ],
        ),
  );

  Future<bool?> showPlayAudioManuallyDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Play Audio'),
          content: const Text(
            'You need to manually activate audio PlayBack for iOS Safari !',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Ignore'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Play Audio'),
            ),
          ],
        ),
  );

  Future<bool?> showUnPublishDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('UnPublish'),
          content: const Text(
            'Would you like to un-publish your Camera & Mic ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('YES'),
            ),
          ],
        ),
  );

  Future<void> showErrorDialog(dynamic exception) => showDialog<void>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text(exception.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
  );

  Future<bool?> showDisconnectDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Disconnect'),
          content: const Text('Are you sure to disconnect?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Disconnect'),
            ),
          ],
        ),
  );

  Future<bool?> showReconnectDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Reconnect'),
          content: const Text('This will force a reconnection'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reconnect'),
            ),
          ],
        ),
  );

  Future<void> showReconnectSuccessDialog() => showDialog<void>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Reconnect'),
          content: const Text('Reconnection was successful.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
  );

  Future<bool?> showSendDataDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Send data'),
          content: const Text(
            'This will send a sample data to all participants in the room',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Send'),
            ),
          ],
        ),
  );

  Future<bool?> showDataReceivedDialog(String data) => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Received data'),
          content: Text(data),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('OK'),
            ),
          ],
        ),
  );

  Future<bool?> showRecordingStatusChangedDialog(bool isActiveRecording) =>
      showDialog<bool>(
        context: this,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Room recording reminder'),
              content: Text(
                isActiveRecording
                    ? 'Room recording is active.'
                    : 'Room recording is stoped.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('OK'),
                ),
              ],
            ),
      );

  Future<bool?> showSubscribePermissionDialog() => showDialog<bool>(
    context: this,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Allow subscription'),
          content: const Text(
            'Allow all participants to subscribe tracks published by local participant?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('YES'),
            ),
          ],
        ),
  );

  Future<SimulateScenarioResult?> showSimulateScenarioDialog() =>
      showDialog<SimulateScenarioResult>(
        context: this,
        builder:
            (ctx) => SimpleDialog(
              title: const Text('Simulate Scenario'),
              children:
                  SimulateScenarioResult.values
                      .map(
                        (e) => SimpleDialogOption(
                          child: Text(e.name),
                          onPressed: () => Navigator.pop(ctx, e),
                        ),
                      )
                      .toList(),
            ),
      );

  Future<bool?> showPodcastPublishedDialog() => showDialog<bool>(
    context: this,
    barrierDismissible: false,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1B2A), // adjust to match your theme
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // icon circle
              SvgPicture.asset(
                Images.microphone,
                height: 36,
                width: 36,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                "Your Podcast is Published",
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "It’s now published and available for you\nand everyone on the call.",
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.75),
                  height: 1.3,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: CustomButton(
                    onPressed: () {
                      Navigator.pop(ctx, true);
                    },
                    btnText: "Continue",
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

enum SimulateScenarioResult {
  signalReconnect,
  fullReconnect,
  speakerUpdate,
  nodeFailure,
  migration,
  serverLeave,
  switchCandidate,
  e2eeKeyRatchet,
  participantName,
  participantMetadata,
  clear,
}
