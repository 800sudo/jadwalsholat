import 'picker/local_file_picker_stub.dart'
    if (dart.library.html) 'picker/local_file_picker_web.dart'
    if (dart.library.io) 'picker/local_file_picker_io.dart';

class LocalFilePickerHelper {
  LocalFilePickerHelper._();

  /// Membuka file explorer lokal / flashdisk dan mengembalikan gambar
  /// dalam format Data URI Base64 (data:image/...;base64,...).
  ///
  /// Bekerja 100% mulus di Web (via HTML5 File API langsung tanpa UnimplementedError)
  /// dan di Android TV / Windows / Mobile (via FilePicker native).
  static Future<String?> pickImageAsBase64() async {
    return await pickImageFileAsBase64();
  }
}
