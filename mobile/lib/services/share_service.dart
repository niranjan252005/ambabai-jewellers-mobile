import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/jewelry_item.dart';
import 'shop_service.dart';
import 'auth_service.dart';

class ShareService {
  static const String baseUrl = 'https://ambabai-jewellers.onrender.com';

  /// Share jewelry item with text and image (online version)
  static Future<void> shareJewelryItem(
    BuildContext context,
    JewelryItem item, {
    bool includeImage = true,
    String? customMessage,
  }) async {
    try {
      // Try to get online share data first
      final shareData = await _getOnlineShareData(item);

      if (shareData != null) {
        // Online mode - share with web link and image
        await _shareOnlineItem(context, item, shareData, customMessage);
      } else {
        // Offline mode - fallback to local sharing
        final shopInfo = await ShopService.getShopInfo();
        final shareText =
            await _generateShareText(item, customMessage, shopInfo);

        if (includeImage && item.imagePath != null) {
          await _shareWithLocalImage(context, item, shareText, shopInfo);
        } else {
          await Share.share(
            shareText,
            subject: '💎 ${item.name} - ${shopInfo['name']}',
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to share item: $e');
    }
  }

  /// Get online share data from server
  static Future<Map<String, dynamic>?> _getOnlineShareData(
      JewelryItem item) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/jewelry/${item.id}/share'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Failed to get online share data: $e');
    }
    return null;
  }

  /// Share online item with web link and image
  static Future<void> _shareOnlineItem(
    BuildContext context,
    JewelryItem item,
    Map<String, dynamic> shareData,
    String? customMessage,
  ) async {
    final buffer = StringBuffer();

    if (customMessage != null) {
      buffer.writeln(customMessage);
      buffer.writeln();
    }

    buffer.writeln('💎 ${item.name}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('💰 Price: ${item.formattedPrice}');
    buffer.writeln('📦 Category: ${item.category}');
    buffer.writeln('⚖️ Weight: ${item.formattedWeight}');
    buffer.writeln('🏷️ Material: ${item.material}');

    if (item.description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('📝 ${item.description}');
    }

    buffer.writeln();
    buffer.writeln('🔗 View Details: ${shareData['shareUrl']}');
    buffer.writeln();

    final shopInfo = shareData['shopInfo'];
    buffer.writeln('🏪 ${shopInfo['name']}');
    buffer.writeln('📞 ${shopInfo['phone']}');
    buffer.writeln('📧 ${shopInfo['email']}');
    buffer.writeln('📍 ${shopInfo['address']}');
    buffer.writeln();
    buffer.writeln('✨ Visit us for more exquisite jewelry!');

    final shareText = buffer.toString();

    // If there's an online image, download and share it
    if (shareData['imageUrl'] != null) {
      try {
        final imageResponse = await http.get(Uri.parse(shareData['imageUrl']));
        if (imageResponse.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final imageFile = File('${tempDir.path}/jewelry_${item.id}.jpg');
          await imageFile.writeAsBytes(imageResponse.bodyBytes);

          await Share.shareXFiles(
            [XFile(imageFile.path)],
            text: shareText,
            subject: '💎 ${item.name} - ${shopInfo['name']}',
          );
          return;
        }
      } catch (e) {
        print('Failed to download image: $e');
      }
    }

    // Fallback to text only
    await Share.share(shareText,
        subject: '💎 ${item.name} - ${shopInfo['name']}');
  }

  /// Share jewelry item specifically to WhatsApp
  static Future<void> shareToWhatsApp(
    BuildContext context,
    JewelryItem item, {
    String? phoneNumber,
  }) async {
    try {
      final shopInfo = await ShopService.getShopInfo();
      final shareText = await _generateWhatsAppText(item, shopInfo);

      if (item.imagePath != null) {
        await _shareWithLocalImage(context, item, shareText, shopInfo,
            forWhatsApp: true);
      } else {
        await Share.share(
          shareText,
          subject: '💎 ${item.name}',
        );
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to share to WhatsApp: $e');
    }
  }

  /// Create and share a beautiful jewelry card image
  static Future<void> shareJewelryCard(
    BuildContext context,
    JewelryItem item,
  ) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create beautiful card image
      final cardImage = await _createJewelryCardImage(item);

      // Hide loading dialog
      Navigator.of(context).pop();

      if (cardImage != null) {
        // Save image to temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/jewelry_card_${item.id}.png');
        await file.writeAsBytes(cardImage);

        // Share the card image with text
        final shopInfo = await ShopService.getShopInfo();
        final shareText = await _generateCardShareText(item, shopInfo);
        await Share.shareXFiles(
          [XFile(file.path)],
          text: shareText,
          subject: '💎 ${item.name} - ${shopInfo['name']}',
        );
      } else {
        // Fallback to text sharing
        await shareJewelryItem(context, item, includeImage: false);
      }
    } catch (e) {
      // Hide loading dialog if still showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar(context, 'Failed to create jewelry card: $e');
    }
  }

  /// Show share options bottom sheet
  static void showShareOptions(BuildContext context, JewelryItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share ${item.name}',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Share options
            _buildShareOption(
              context,
              icon: Icons.share,
              title: 'Share Item',
              subtitle: 'Share with text and image',
              onTap: () {
                Navigator.pop(context);
                shareJewelryItem(context, item);
              },
            ),

            _buildShareOption(
              context,
              icon: Icons.message,
              title: 'Share to WhatsApp',
              subtitle: 'Share directly to WhatsApp',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                shareToWhatsApp(context, item);
              },
            ),

            _buildShareOption(
              context,
              icon: Icons.image,
              title: 'Share Beautiful Card',
              subtitle: 'Create and share jewelry card',
              color: const Color(0xFFD4AF37),
              onTap: () {
                Navigator.pop(context);
                shareJewelryCard(context, item);
              },
            ),

            _buildShareOption(
              context,
              icon: Icons.text_fields,
              title: 'Share Text Only',
              subtitle: 'Share item details as text',
              onTap: () {
                Navigator.pop(context);
                shareJewelryItem(context, item, includeImage: false);
              },
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate formatted share text
  static Future<String> _generateShareText(JewelryItem item,
      String? customMessage, Map<String, String> shopInfo) async {
    final buffer = StringBuffer();

    if (customMessage != null) {
      buffer.writeln(customMessage);
      buffer.writeln();
    }

    buffer.writeln('💎 ${item.name}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('💰 Price: ${item.formattedPrice}');
    buffer.writeln('📦 Category: ${item.category}');
    buffer.writeln('⚖️ Weight: ${item.formattedWeight}');
    buffer.writeln('🏷️ Material: ${item.material}');

    if (item.brand != null) {
      buffer.writeln('🏪 Brand: ${item.brand}');
    }

    if (item.size != null) {
      buffer.writeln('📏 Size: ${item.size}');
    }

    if (item.hasMeltingData) {
      buffer.writeln();
      buffer.writeln('⚖️ MELTING DATA:');
      if (item.karat != null) buffer.writeln('• Karat: ${item.karat}K');
      if (item.purity != null) buffer.writeln('• Purity: ${item.purity}');
      if (item.meltingWeight != null)
        buffer.writeln('• Melting Weight: ${item.formattedMeltingWeight}');
      if (item.meltingValue != null)
        buffer.writeln('• Melting Value: ${item.formattedMeltingValue}');
    }

    if (item.description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('📝 ${item.description}');
    }

    buffer.writeln();
    buffer.writeln('🏪 ${shopInfo['name']}');
    buffer.writeln('📞 ${shopInfo['phone']}');
    buffer.writeln('📧 ${shopInfo['email']}');
    buffer.writeln('📍 ${shopInfo['address']}');
    buffer.writeln();
    buffer.writeln('✨ Visit us for more exquisite jewelry!');

    return buffer.toString();
  }

  /// Generate WhatsApp-specific share text
  static Future<String> _generateWhatsAppText(
      JewelryItem item, Map<String, String> shopInfo) async {
    final buffer = StringBuffer();

    buffer.writeln('*💎 ${item.name}*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('💰 *Price:* ${item.formattedPrice}');
    buffer.writeln('📦 *Category:* ${item.category}');
    buffer.writeln('⚖️ *Weight:* ${item.formattedWeight}');
    buffer.writeln('🏷️ *Material:* ${item.material}');

    if (item.brand != null) {
      buffer.writeln('🏪 *Brand:* ${item.brand}');
    }

    if (item.hasMeltingData && item.karat != null) {
      buffer.writeln('💎 *Karat:* ${item.karat}K');
    }

    if (item.description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('📝 ${item.description}');
    }

    buffer.writeln();
    buffer.writeln('🏪 *${shopInfo['name']}*');
    buffer.writeln('📞 ${shopInfo['phone']}');
    buffer.writeln('📧 ${shopInfo['email']}');
    buffer.writeln('📍 ${shopInfo['address']}');
    buffer.writeln();
    buffer.writeln('✨ _Visit us for more exquisite jewelry!_');

    return buffer.toString();
  }

  /// Generate card share text
  static Future<String> _generateCardShareText(
      JewelryItem item, Map<String, String> shopInfo) async {
    return '💎 ${item.name} - ${item.formattedPrice}\n\n'
        '🏪 ${shopInfo['name']}\n'
        '📞 ${shopInfo['phone']}\n'
        '📧 ${shopInfo['email']}\n'
        '📍 ${shopInfo['address']}\n\n'
        '✨ Visit us for more exquisite jewelry!';
  }

  /// Share with local image (offline mode)
  static Future<void> _shareWithLocalImage(
    BuildContext context,
    JewelryItem item,
    String text,
    Map<String, String> shopInfo, {
    bool forWhatsApp = false,
  }) async {
    try {
      if (item.imagePath != null) {
        final imageFile = File(item.imagePath!);
        if (await imageFile.exists()) {
          await Share.shareXFiles(
            [XFile(imageFile.path)],
            text: text,
            subject: '💎 ${item.name} - ${shopInfo['name']}',
          );
          return;
        }
      }

      // Fallback to text only
      await Share.share(text, subject: '💎 ${item.name} - ${shopInfo['name']}');
    } catch (e) {
      await Share.share(text, subject: '💎 ${item.name}');
    }
  }

  /// Create beautiful jewelry card image
  static Future<Uint8List?> _createJewelryCardImage(JewelryItem item) async {
    try {
      // This would create a beautiful card image programmatically
      // For now, we'll return null and fallback to text sharing
      // In a full implementation, you would use CustomPainter or widgets to image
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Build share option widget
  static Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Colors.blue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? Colors.blue),
      ),
      title: Text(
        title,
        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
      ),
      onTap: onTap,
    );
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Copy item details to clipboard
  static Future<void> copyToClipboard(
    BuildContext context,
    JewelryItem item,
  ) async {
    final shopInfo = await ShopService.getShopInfo();
    final text = await _generateShareText(item, null, shopInfo);
    await Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item details copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
