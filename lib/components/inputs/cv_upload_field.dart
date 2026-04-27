import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadField extends StatefulWidget {
  const FileUploadField({super.key});

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  Widget _buildFileIcon(String extension) {
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attach Document',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        _selectedFile == null ? _buildUploadArea() : _buildFilePreview(),
      ],
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_file_outlined, size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text(
              'Tap to upload a file',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              'PDF or DOCX supported',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    final file = _selectedFile!;
    final extension = file.extension ?? '';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildFileIcon(extension),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatFileSize(file.size),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: GestureDetector(
            onTap: _removeFile,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 1)),
                ],
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}