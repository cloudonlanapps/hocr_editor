import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OCRImageNotifier extends StateNotifier<OCRImage?> {
  OCRImage? ocrImage;
  OCRImageNotifier({this.ocrImage}) : super(ocrImage);

  set xml(String xml) {
    state = state?.copyWith(xml: xml);
  }

  set newOCRImage(OCRImage image) => state = state = image;
}

final ocrImageNotifierProvider =
    StateNotifierProvider.autoDispose<OCRImageNotifier, OCRImage?>((ref) {
  throw Exception("You must  override this provider to use");
});
