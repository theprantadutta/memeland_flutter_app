import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';

class SharingService {
  static Future<void> shareMeme({
    required String imageUrl,
    required String caption,
    BuildContext? context,
  }) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/meme_share.png');
      await file.writeAsBytes(Uint8List.fromList(response.data!));

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: caption,
        ),
      );
    } catch (e) {
      await SharePlus.instance.share(
        ShareParams(text: '$caption\n\nShared from Memeland'),
      );
    }
  }

  static Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }
}
