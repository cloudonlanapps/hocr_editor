import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

extension UIImage on img.Image {
  Future<ui.Image> toUiImage() async {
    ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
        getBytes(format: img.Format.rgba));
    ui.ImageDescriptor id = ui.ImageDescriptor.raw(buffer,
        height: height, width: width, pixelFormat: ui.PixelFormat.rgba8888);
    ui.Codec codec =
        await id.instantiateCodec(targetHeight: height, targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image uiImage = fi.image;
    return uiImage;
  }
}
