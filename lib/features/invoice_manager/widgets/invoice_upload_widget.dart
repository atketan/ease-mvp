import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../bloc/invoice_manager_cubit.dart';

class InvoiceUploadWidget extends StatefulWidget {
  @override
  _InvoiceUploadWidgetState createState() => _InvoiceUploadWidgetState();
}

class _InvoiceUploadWidgetState extends State<InvoiceUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });
        await _uploadFile(pickedFile);
      }
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera permission is required to pick images.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadFile(XFile file) async {
    try {
      final fileName = path.basename(file.path);
      final storageRef = FirebaseStorage.instance.ref().child('invoices/$fileName');
      final uploadTask = storageRef.putFile(File(file.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      context.read<InvoiceManagerCubit>().updateInvoiceUrl(downloadUrl);
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: Text('Pick Image from Camera'),
        ),
        OutlinedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: Text('Pick Image from Gallery'),
        ),
        if (_isUploading) CircularProgressIndicator(),
      ],
    );
  }
}