import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/pages/prejoin.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../exts.dart';
import '../widgets/text_field.dart';

class ConnectPage extends StatefulWidget {
  //
  const ConnectPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  //
  static const _storeKeyUri = 'uri';
  static const _storeKeyToken = 'token';
  static const _storeKeySimulcast = 'simulcast';
  static const _storeKeyAdaptiveStream = 'adaptive-stream';
  static const _storeKeyDynacast = 'dynacast';
  static const _storeKeyE2EE = 'e2ee';
  static const _storeKeySharedKey = 'shared-key';
  static const _storeKeyMultiCodec = 'multi-codec';
  static const _storeKeyPreferredCodec = 'preferred-codec';

  // final _uriCtrl = TextEditingController();
  // final _tokenCtrl = TextEditingController();
  final _sharedKeyCtrl = TextEditingController();
  bool _simulcast = true;
  bool _adaptiveStream = true;
  bool _dynacast = true;
  bool _busy = false;
  bool _e2ee = false;
  bool _multiCodec = false;
  String _preferredCodec = 'VP8';
  final url ="wss://lagecy-87n09bcj.livekit.cloud"; //"wss://legacy-sync-ung5b93a.livekit.cloud";//_uriCtrl.text;
  String token = '';//_tokenCtrl.text;
  @override
  void initState() {
    super.initState();
    unawaited(_readPrefs());
    if (lkPlatformIs(PlatformType.android)) {
      unawaited(_checkPermissions());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.bluetooth.request();
    if (status.isPermanentlyDenied) {
      print('Bluetooth Permission disabled');
    }

    status = await Permission.bluetoothConnect.request();
    if (status.isPermanentlyDenied) {
      print('Bluetooth Connect Permission disabled');
    }

    status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      print('Camera Permission disabled');
    }

    status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      print('Microphone Permission disabled');
    }
  }

  // Read saved URL and Token
  Future<void> _readPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    token = const bool.hasEnvironment('TOKEN')
        ? const String.fromEnvironment('TOKEN')
        : prefs.getString(_storeKeyToken) ?? '';
    _sharedKeyCtrl.text = const bool.hasEnvironment('E2EEKEY')
        ? const String.fromEnvironment('E2EEKEY')
        : prefs.getString(_storeKeySharedKey) ?? '';
    setState(() {
      _simulcast = prefs.getBool(_storeKeySimulcast) ?? true;
      _adaptiveStream = prefs.getBool(_storeKeyAdaptiveStream) ?? true;
      _dynacast = prefs.getBool(_storeKeyDynacast) ?? true;
      _e2ee = prefs.getBool(_storeKeyE2EE) ?? false;
      _multiCodec = prefs.getBool(_storeKeyMultiCodec) ?? false;
      _preferredCodec = prefs.getString(_storeKeyPreferredCodec) ?? 'VP8';
    });
  }

  // Save URL and Token
  Future<void> _writePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeKeyToken, token);
    await prefs.setString(_storeKeySharedKey, _sharedKeyCtrl.text);
    await prefs.setBool(_storeKeySimulcast, _simulcast);
    await prefs.setBool(_storeKeyAdaptiveStream, _adaptiveStream);
    await prefs.setBool(_storeKeyDynacast, _dynacast);
    await prefs.setBool(_storeKeyE2EE, _e2ee);
    await prefs.setBool(_storeKeyMultiCodec, _multiCodec);
    await prefs.setString(_storeKeyPreferredCodec, _preferredCodec);
  }
  String randomUserName() {
    return "user_${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<String> fetchLiveKitToken() async {
    final roomName = _sharedKeyCtrl.text.trim();

    if (roomName.isEmpty) {
      throw Exception("Room name empty hai");
    }

    final userName = randomUserName();

    print('ROOM SENT => $roomName');
    print('USER SENT => $userName');

    final response = await http.post(
      Uri.parse('https://cloud-api.livekit.io/api/sandbox/connection-details'),
      headers: {
        'Content-Type': 'application/json',
        'X-Sandbox-ID': 'legacy-audio-242zdl',
      },
      body: jsonEncode({
        'room_name': roomName,
        'participant_name': userName,
      }),
    );

    print("LIVEKIT RESPONSE => ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['participantToken'];
    } else {
      throw Exception("Token error");
    }
  }


  Future<void> _connect(BuildContext ctx) async {
    //
    try {
      setState(() {
        _busy = true;
      });

      // Save URL and Token for convenience
      await _writePrefs();
      final response = await fetchLiveKitToken();
      token=response;

      final e2eeKey = _sharedKeyCtrl.text;
      if (!ctx.mounted) return;
      await Navigator.push<void>(
        ctx,
        MaterialPageRoute(
            builder: (_) => PreJoinPage(
              args: JoinArgs(
                url: url,
                token: token,
                e2ee: _e2ee,
                e2eeKey: e2eeKey,
                simulcast: _simulcast,
                adaptiveStream: _adaptiveStream,
                dynacast: _dynacast,
                preferredCodec: _preferredCodec,
                enableBackupVideoCodec: ['VP9', 'AV1'].contains(_preferredCodec),
              ),
            )),
      );
    } catch (error) {
      print('Could not connect $error');
      if (!ctx.mounted) return;
      await ctx.showErrorDialog(error);
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  void _setSimulcast(bool? value) async {
    if (value == null || _simulcast == value) return;
    setState(() {
      _simulcast = value;
    });
  }

  void _setE2EE(bool? value) async {
    if (value == null || _e2ee == value) return;
    setState(() {
      _e2ee = value;
    });
  }

  void _setAdaptiveStream(bool? value) async {
    if (value == null || _adaptiveStream == value) return;
    setState(() {
      _adaptiveStream = value;
    });
  }

  void _setDynacast(bool? value) async {
    if (value == null || _dynacast == value) return;
    setState(() {
      _dynacast = value;
    });
  }

  void _setMultiCodec(bool? value) async {
    if (value == null || _multiCodec == value) return;
    setState(() {
      _multiCodec = value;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 70),
                    child: Text("Demo")
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: LKTextField(
                  label: 'Room Name',
                  ctrl: _sharedKeyCtrl,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text('E2EE'),
              //       Switch(
              //         value: _e2ee,
              //         onChanged: (value) => _setE2EE(value),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text('Simulcast'),
              //       Switch(
              //         value: _simulcast,
              //         onChanged: (value) => _setSimulcast(value),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text('Adaptive Stream'),
              //       Switch(
              //         value: _adaptiveStream,
              //         onChanged: (value) => _setAdaptiveStream(value),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text('Dynacast'),
              //       Switch(
              //         value: _dynacast,
              //         onChanged: (value) => _setDynacast(value),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: _multiCodec ? 5 : 25),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text('Multi Codec'),
              //       Switch(
              //         value: _multiCodec,
              //         onChanged: (value) => _setMultiCodec(value),
              //       ),
              //     ],
              //   ),
              // ),
              // if (_multiCodec)
              //   Padding(
              //       padding: const EdgeInsets.only(bottom: 5),
              //       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //         const Text('Preferred Codec:'),
              //         DropdownButton<String>(
              //           value: _preferredCodec,
              //           icon: const Icon(
              //             Icons.arrow_drop_down,
              //             color: Colors.blue,
              //           ),
              //           elevation: 16,
              //           style: const TextStyle(color: Colors.blue),
              //           underline: Container(
              //             height: 2,
              //             color: Colors.blueAccent,
              //           ),
              //           onChanged: (String? value) {
              //             if (value == null) return;
              //             setState(() {
              //               _preferredCodec = value;
              //             });
              //             unawaited(_writePrefs());
              //           },
              //           items: ['Preferred Codec', 'AV1', 'VP9', 'VP8', 'H264', 'H265']
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         )
              //       ])),
              ElevatedButton(
                onPressed: _busy ? null : () => _connect(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    const Text('CONNECT'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
