import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/jewelry_item.dart';
import '../services/share_service.dart';

class ShareButton extends StatelessWidget {
  final JewelryItem item;
  final ShareButtonStyle style;
  final String? customText;
  final IconData? customIcon;
  final Color? customColor;

  const ShareButton({
    super.key,
    required this.item,
    this.style = ShareButtonStyle.icon,
    this.customText,
    this.customIcon,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ShareButtonStyle.icon:
        return _buildIconButton(context);
      case ShareButtonStyle.outlined:
        return _buildOutlinedButton(context);
      case ShareButtonStyle.filled:
        return _buildFilledButton(context);
      case ShareButtonStyle.text:
        return _buildTextButton(context);
      case ShareButtonStyle.fab:
        return _buildFabButton(context);
    }
  }

  Widget _buildIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        customIcon ?? Icons.share,
        color: customColor ?? const Color(0xFFD4AF37),
      ),
      onPressed: () => ShareService.showShareOptions(context, item),
      tooltip: 'Share ${item.name}',
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => ShareService.showShareOptions(context, item),
      icon: Icon(
        customIcon ?? Icons.share,
        size: 18,
      ),
      label: Text(customText ?? 'Share'),
      style: OutlinedButton.styleFrom(
        foregroundColor: customColor ?? const Color(0xFFD4AF37),
        side: BorderSide(color: customColor ?? const Color(0xFFD4AF37)),
      ),
    );
  }

  Widget _buildFilledButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => ShareService.showShareOptions(context, item),
      icon: Icon(
        customIcon ?? Icons.share,
        size: 18,
      ),
      label: Text(customText ?? 'Share'),
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor ?? const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => ShareService.showShareOptions(context, item),
      icon: Icon(
        customIcon ?? Icons.share,
        size: 18,
      ),
      label: Text(customText ?? 'Share'),
      style: TextButton.styleFrom(
        foregroundColor: customColor ?? const Color(0xFFD4AF37),
      ),
    );
  }

  Widget _buildFabButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => ShareService.showShareOptions(context, item),
      backgroundColor: customColor ?? const Color(0xFFD4AF37),
      child: Icon(
        customIcon ?? Icons.share,
        color: Colors.white,
      ),
    );
  }
}

enum ShareButtonStyle {
  icon,
  outlined,
  filled,
  text,
  fab,
}

class QuickShareButtons extends StatelessWidget {
  final JewelryItem item;

  const QuickShareButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Share',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // WhatsApp Share
              Expanded(
                child: _buildQuickShareButton(
                  context,
                  icon: Icons.message,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onTap: () => ShareService.shareToWhatsApp(context, item),
                ),
              ),
              const SizedBox(width: 8),
              
              // General Share
              Expanded(
                child: _buildQuickShareButton(
                  context,
                  icon: Icons.share,
                  label: 'Share',
                  color: Colors.blue,
                  onTap: () => ShareService.shareJewelryItem(context, item),
                ),
              ),
              const SizedBox(width: 8),
              
              // Copy to Clipboard
              Expanded(
                child: _buildQuickShareButton(
                  context,
                  icon: Icons.copy,
                  label: 'Copy',
                  color: Colors.orange,
                  onTap: () => ShareService.copyToClipboard(context, item),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickShareButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareFab extends StatelessWidget {
  final JewelryItem item;
  final VoidCallback? onPressed;

  const ShareFab({
    super.key,
    required this.item,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed ?? () => ShareService.showShareOptions(context, item),
      backgroundColor: const Color(0xFFD4AF37),
      child: const Icon(Icons.share, color: Colors.white),
    );
  }
}