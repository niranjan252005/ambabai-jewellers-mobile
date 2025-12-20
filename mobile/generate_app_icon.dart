import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'lib/widgets/custom_logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create app icon directory
  final iconDir = Directory('assets/icon');
  if (!iconDir.existsSync()) {
    iconDir.createSync(recursive: true);
  }
  
  // Generate app icon
  await generateAppIcon();
  
  print('✅ App icon generated successfully!');
  print('📁 Location: assets/icon/app_icon.png');
  print('🔧 Run: flutter packages pub run flutter_launcher_icons:main');
  
  exit(0);
}

Future<void> generateAppIcon() async {
  // Create a widget to render
  final widget = Container(
    width: 512,
    height: 512,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(100),
    ),
    child: const Center(
      child: CustomLogo(
        size: 300,
        color: Colors.white,
        showBackground: false,
      ),
    ),
  );

  // Create a RepaintBoundary to capture the widget
  final repaintBoundary = RepaintBoundary(
    child: MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: widget),
      ),
    ),
  );

  // Render the widget to an image
  final renderObject = RenderRepaintBoundary();
  final pipelineOwner = PipelineOwner();
  final buildOwner = BuildOwner(focusManager: FocusManager());
  
  final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: renderObject,
    child: repaintBoundary,
  ).attachToRenderTree(buildOwner);
  
  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();
  
  pipelineOwner.rootNode = renderObject;
  renderObject.attach(pipelineOwner);
  
  // Layout and paint
  renderObject.layout(const BoxConstraints(
    minWidth: 512,
    maxWidth: 512,
    minHeight: 512,
    maxHeight: 512,
  ));
  
  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();
  
  // Capture the image
  final image = await renderObject.toImage(pixelRatio: 1.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();
  
  // Save the image
  final file = File('assets/icon/app_icon.png');
  await file.writeAsBytes(bytes);
}