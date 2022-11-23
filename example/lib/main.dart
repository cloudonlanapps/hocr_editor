import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocr_editor/hocr_editor.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HOCR Editor',
      home: HOCRDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HOCRDemo extends StatefulWidget {
  const HOCRDemo({super.key});

  @override
  State<HOCRDemo> createState() => _HOCRDemoState();
}

class _HOCRDemoState extends State<HOCRDemo> {
  bool isSaving = false;

  Future<OCRImage?> loadAssets() async {
    final ByteData bytes = await rootBundle.load('assets/sample1.jpg');

    return await OCRImage.fromOCRData(
      image: bytes.buffer.asUint8List(),
      lang1: 'hi',
      xmlString: await rootBundle.loadString('assets/sample1.hocr'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("HOCR Editor Demo"),
        ),
        body: FutureBuilder(
          future: loadAssets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Wait while loading the asset resources"),
                  CircularProgressIndicator(),
                ],
              ));
            }
            if (snapshot.data == null) {
              return const Center(
                  child: Text("Failed loading the asset resources"));
            }

            return Stack(
              children: [
                HOCREditor(
                  ocrImage: snapshot.data as OCRImage,
                  ocrViewController: HOCREditingController(
                      edit: true,
                      onDiscardImage: () {},
                      onCopyToClipboard: (text) {},
                      onDictLookup: (String text, {required String lang}) {},
                      onSaveImage: (img) async {
                        setState(() {
                          isSaving = true;
                        });

                        // Save here
                        setState(() {
                          isSaving = false;
                        });
                        return img;
                      }),
                ),
                if (isSaving) const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
