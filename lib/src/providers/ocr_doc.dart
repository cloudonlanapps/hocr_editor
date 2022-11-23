import 'package:dart_hocr/dart_hocr.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ocr_image.dart';

class OCREngine extends StateNotifier<AsyncValue<HOCRDoc?>> {
  final OCRImage? ocrImage;
  OCREngine({
    required this.ocrImage,
  }) : super(const AsyncValue.loading()) {
    if (ocrImage != null) {
      load();
    }
  }

  void load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return HOCRImport.fromXMLString(xmlString: ocrImage!.xml);
    });
  }

  void reload(HOCRDoc doc) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return doc;
    });
  }

  void toggleDisable(String id) {
    state.whenData((value) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
          () async => value?.disable(id: id, disabled: !value.isDisabled(id)));
    });
  }

  void replaceText(String id, String newText) {
    state.whenData((value) async {
      state = const AsyncValue.loading();
      state =
          await AsyncValue.guard(() async => value?.replaceText(id, newText));
    });
  }
}

final ocrDataProvider =
    StateNotifierProvider.autoDispose<OCREngine, AsyncValue<HOCRDoc?>>((ref) {
  final ocrImage = ref.watch(ocrImageNotifierProvider);

  return OCREngine(ocrImage: ocrImage);
}, dependencies: [ocrImageNotifierProvider]);
