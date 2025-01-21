import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRScreen extends StatefulWidget {
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  String _extractedText = '';
  List<String> _textList = []; // เก็บข้อความที่ตรวจจับได้ทั้งหมด
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      await _recognizeText(_selectedImage!);
    }
  }

  /// ฟังก์ชันตรวจจับข้อความและเก็บข้อความลงใน List<String>
  Future<void> _recognizeText(File image) async {
    final InputImage inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // เคลียร์ข้อมูลเดิมก่อนตรวจจับใหม่
    // _textList.clear();

    // เก็บข้อความที่ตรวจจับได้ลงใน List<String>
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        _textList.add(line.text);
      }
    }

    // รวมข้อความทั้งหมดเป็น String เดียวเพื่อแสดงผล
    _extractedText = _textList.join('\n');

    // อัปเดต UI เพื่อแสดงผล
    setState(() {
      print("_textList " + _textList.toString());
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter OCR Thai Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null ? Image.file(_selectedImage!) : Icon(Icons.image, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('เลือกภาพ'),
              ),
              SizedBox(height: 20),
              Text(
                'ข้อความที่ตรวจจับได้:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _extractedText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'ข้อความแยกบรรทัด:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _textList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_textList[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
