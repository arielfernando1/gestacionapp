import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../firebase_controllers/firestore_controller.dart';

class AudioPage extends StatefulWidget {
  final firestore = Firestore();
  AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final recorder = FlutterSoundRecorder();
  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    saveToDatabase(audioFile);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    //save to firestore
  }

  saveToDatabase(File audio) async {
    late String? user = FirebaseAuth.instance.currentUser?.uid.toString();
    // convert audio to bytes
    final bytes = await audio.readAsBytes();
    // convert bytes to base64
    final base64 = base64Encode(bytes);
    // save to firestore
    final Post post = Post(
      id: '',
      uuid: user.toString(),
      title: 'Audio',
      description: 'Audio description',
      postType: 2,
      date: DateTime.now(),
      file: base64,
    );
    await widget.firestore.addPost(post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration =
                  snapshot.hasData ? snapshot.data!.duration : Duration.zero;
              String twoDigits(int n) => n.toString().padLeft(2, '0');
              final twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
              final twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));
              return Text(
                '$twoDigitMinutes:$twoDigitSeconds',
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                ),
              );
            },
          ),
          ElevatedButton(
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              },
              child: Icon(
                recorder.isRecording ? Icons.stop : Icons.mic,
                size: 30,
              )),
        ],
      )
          // IconButton(
          //   icon: Icon(
          //     recorder.isRecording ? Icons.stop : Icons.mic,
          //     size: 30,
          //   ),
          //   onPressed: () async {
          //     if (recorder.isRecording) {
          //       await stop();
          //     } else {
          //       await record();
          //     }
          //     setState(() {});
          //   },
          // ),
          ),
    );
  }
}
