import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for clipboard
import 'package:camera/camera.dart'; // Import camera package
import 'package:zoom_clone/Features/Meetings/Repository/meeting_repository_implementation.dart';
import 'package:zoom_clone/Features/Meetings/Screens/join_meeting_screen.dart';
import 'package:zoom_clone/Features/Meetings/Widgets/custom_buttons.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final MeetingRepositoryImplementation _meetingRepositoryImplementation =
      MeetingRepositoryImplementation();

  String? meetingId;
  CameraController? _cameraController;
  bool isRecording = false;
  bool isCameraInitialized = false;

  // Initialize the camera only when starting a new meeting
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
        await _cameraController!.initialize();
        setState(() {
          isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  // Start recording video (Only if camera is initialized)
  Future<void> _startRecording() async {
    if (_cameraController == null || !isCameraInitialized) {
      debugPrint("Camera not initialized. Cannot start recording.");
      return;
    }
    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        isRecording = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint("Error starting recording: $e");
    }
  }

  // Stop recording video
  Future<void> _stopRecording() async {
    if (_cameraController == null || !isRecording) return;

    try {
      await _cameraController!.stopVideoRecording();
      setState(() {
        isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording stopped'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  void createNewMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 10000000).toString();

    try {
      _meetingRepositoryImplementation.createMeeting(roomName);
      setState(() {
        meetingId = roomName;
      });

      // Copy the meeting ID to clipboard
      Clipboard.setData(ClipboardData(text: roomName));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meeting Created! ID copied to clipboard: $roomName'),
          duration: const Duration(seconds: 3),
        ),
      );

      // Initialize and start the camera after meeting creation
      await _initializeCamera();
      if (isCameraInitialized) {
        _startRecording();
      }
    } catch (e) {
      debugPrint('Error creating meeting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating meeting: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Meetings',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isCameraInitialized)
              Expanded(
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: createNewMeeting,
                    child: const CustomButton(
                      text: 'New Meeting',
                      color: Colors.deepOrange,
                      icon: Icons.videocam_sharp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const JoinMeetingScreen();
                        },
                      ));
                    },
                    child: const CustomButton(
                      text: 'Join',
                      color: Color.fromRGBO(45, 101, 246, 1),
                      icon: Icons.add_box,
                    ),
                  ),
                ],
              ),
            ),

            if (meetingId != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Meeting ID: $meetingId',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

            if (isRecording)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: _stopRecording,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Stop Recording"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
