// import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toksort_frontend/services/api_services.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  bool isLoading = false;
  String? fileName;

  Future<void> pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    final pickedFile = result.files.single;

    if (pickedFile.bytes == null && pickedFile.path == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("File tidak valid")));
      return;
    }

    setState(() {
      isLoading = true;
      fileName = pickedFile.name;
    });

    final success = await ApiService.uploadFile(
      fileName: pickedFile.name,
      filePath: pickedFile.path,
      bytes: pickedFile.bytes,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload berhasil")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: pickAndUploadFile,
                      child: const Text("Pilih File CSV"),
                    ),

                    const SizedBox(height: 12),

                    if (fileName != null)
                      Text(
                        "File: $fileName",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
      ),
    );
  }
}
