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
  String downloadUrl = "";

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
      final storageRef =
          FirebaseStorage.instance.ref().child('invoices/$fileName');
      final uploadTask = storageRef.putFile(File(file.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      downloadUrl = await snapshot.ref.getDownloadURL();

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: (downloadUrl.isEmpty)
                ? Card(
                    elevation: 1,
                    child: Container(
                      width: double.maxFinite,
                      height: 150,
                      child: Center(
                        child: (_isUploading)
                            ? CircularProgressIndicator()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Upload invoice '),
                                  InkWell(
                                    onTap: () =>
                                        _pickImage(ImageSource.gallery),
                                    child: Text(
                                      'from Gallery',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.blue[700],
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                  Text(' or '),
                                  InkWell(
                                    onTap: () => _pickImage(ImageSource.camera),
                                    child: Text(
                                      'from Camera',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.blue[700],
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )
                : Image.network(
                    downloadUrl,
                    fit: BoxFit.fitHeight,
                  ),
          ),
          // SizedBox(width: 16.0),
          // Expanded(
          //   flex: 3,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // Text('Upload from'),
          //       ElevatedButton(
          //         onPressed: () => _pickImage(ImageSource.camera),
          //         child: Text('Camera'),
          //         style: OutlinedButton.styleFrom(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //           ),
          //         ),
          //       ),
          //       ElevatedButton(
          //         onPressed: () => _pickImage(ImageSource.gallery),
          //         child: Text('Gallery'),
          //         style: OutlinedButton.styleFrom(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //           ),
          //         ),
          //       ),
          //       if (_isUploading) CircularProgressIndicator(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
