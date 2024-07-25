import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(const DreamFlowApp());
}



class DreamFlowApp extends StatelessWidget {
  const DreamFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageBytes;
  String? _imageName;
  String _userDescription = '';
  String _aiResponse = '';
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    Uint8List? image;
    if (source == ImageSource.camera) {
      image = await ImagePickerWeb.getImageAsBytes();
    } else {
      image = await ImagePickerWeb.getImageAsBytes();
    }
    if (image != null) {
      setState(() {
        _imageBytes = image;
        _imageName =
            source == ImageSource.camera ? 'Captured Image' : 'Selected Image';
      });
    }
  }

  Future<void> _processImage() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
      _aiResponse = '';
    });

    try {
      final base64Image = base64Encode(_imageBytes!);
      final payload = {
        'description': _userDescription,
        'image_base64': base64Image,
      };

      final response = await http.post(
        Uri.parse(
            'https://2c6658ba-4c02-478e-865b-240e5a539e79-00-1vaessxw8fe3u.pike.replit.dev/analyze-image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        setState(() {
          _aiResponse = json.decode(response.body)['response'];
        });
      } else {
        throw Exception('Failed to get response from the server');
      }
    } catch (e) {
      setState(() {
        _aiResponse = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DreamFlow'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(_imageBytes!, height: 200),
              ),
            if (_imageName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_imageName!,
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter additional description (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _userDescription = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _processImage,
              icon: const Icon(Icons.psychology),
              label: const Text('Analyze Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_aiResponse.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade50,
                ),
                child: Text(
                  _aiResponse,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum ImageSource { camera, gallery }



















// import 'package:flutter/material.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:typed_data';

// void main() {
//   runApp(const DreamFlowApp());
// }

// class DreamFlowApp extends StatelessWidget {
//   const DreamFlowApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DreamFlow',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Uint8List? _imageBytes;
//   String? _imageName;
//   String _userDescription = '';
//   String _aiResponse = '';
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     final image = await ImagePickerWeb.getImageAsBytes();
//     if (image != null) {
//       setState(() {
//         _imageBytes = image;
//         _imageName = 'Selected Image';
//       });
//     }
//   }

//   Future<void> _processImage() async {
//     if (_imageBytes == null) return;

//     setState(() {
//       _isLoading = true;
//       _aiResponse = '';
//     });

//     try {
//       final base64Image = base64Encode(_imageBytes!);
//       final payload = {
//         'description': _userDescription,
//         'image_base64': base64Image,
//       };

//       final response = await http.post(
//         Uri.parse(
//             'https://2c6658ba-4c02-478e-865b-240e5a539e79-00-1vaessxw8fe3u.pike.replit.dev/analyze-image'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(payload),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _aiResponse = json.decode(response.body)['response'];
//         });
//       } else {
//         throw Exception('Failed to get response from the server');
//       }
//     } catch (e) {
//       setState(() {
//         _aiResponse = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('DreamFlow'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton.icon(
//               onPressed: _pickImage,
//               icon: const Icon(Icons.image),
//               label: const Text('Choose Image'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (_imageBytes != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.memory(_imageBytes!, height: 200),
//               ),
//             if (_imageName != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(_imageName!,
//                     style: const TextStyle(fontStyle: FontStyle.italic)),
//               ),
//             const SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Enter additional description (optional)',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//               maxLines: 3,
//               onChanged: (value) {
//                 setState(() {
//                   _userDescription = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : _processImage,
//               icon: const Icon(Icons.psychology),
//               label: const Text('Analyze Image'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (_isLoading) const Center(child: CircularProgressIndicator()),
//             if (_aiResponse.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue.shade200),
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.blue.shade50,
//                 ),
//                 child: Text(
//                   _aiResponse,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
