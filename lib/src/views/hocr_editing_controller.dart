import 'package:dart_hocr/dart_hocr.dart';

class HOCREditingController {
  final bool edit;
  final void Function()? onDiscardImage;
  final Future<OCRImage?> Function(OCRImage image, {bool asStory})? onSaveImage;
  final Function(String text)? onCopyToClipboard;
  final Function(String text, {required String lang})? onDictLookup;
  HOCREditingController({
    this.edit = true,
    this.onDiscardImage,
    this.onSaveImage,
    this.onCopyToClipboard,
    this.onDictLookup,
  });
}
