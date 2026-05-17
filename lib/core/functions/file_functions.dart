import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<PlatformFile?> pickDocument(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'docx'],
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;
    final ext = file.extension?.toLowerCase() ?? '';

    if (ext != 'pdf' && ext != 'docx') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only PDF or DOCX files are allowed'),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }
    return file;
  }
  return null;
}

void removeFile(Function(PlatformFile?) onRemove) {
  onRemove(null);
}

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

Widget buildFileIcon(String extension) {
  final isPdf = extension.toLowerCase() == 'pdf';
  return Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: isPdf ? Colors.red.shade50 : Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        isPdf ? 'PDF' : 'DOC',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isPdf ? Colors.red.shade700 : Colors.blue.shade700,
        ),
      ),
    ),
  );
}