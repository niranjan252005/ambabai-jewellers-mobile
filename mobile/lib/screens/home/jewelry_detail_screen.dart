import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../models/jewelry_item.dart';
import '../../services/api_service.dart';
import '../../services/share_service.dart';
import '../../widgets/custom_logo.dart';
import '../../widgets/share_button.dart';

class JewelryDetailScreen extends StatefulWidget {
  final JewelryItem item;

  const JewelryDetailScreen({super.key, required this.item});

  @override
  State<JewelryDetailScreen> createState() => _JewelryDetailScreenState();
}

class _JewelryDetailScreenState extends State<JewelryDetailScreen> {
  int _quantity = 1;
  bool _isOrdering = false;

  void _showImageZoom(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: widget.item.imagePath != null && File(widget.item.imagePath!).existsSync()
                  ? InteractiveViewer(
                      panEnabled: true,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.file(
                        File(widget.item.imagePath!),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const CustomLogo(
                        size: 80,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.item.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!widget.item.isInStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This item is out of stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isOrdering = true;
    });

    final result = await ApiService.placeOrder(widget.item.id, _quantity);

    setState(() {
      _isOrdering = false;
    });

    if (result['success']) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Order Placed'),
            content: const Text('Your order has been placed successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              // Share Button
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => ShareService.showShareOptions(context, widget.item),
              ),
              // More Options
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'share_whatsapp':
                      ShareService.shareToWhatsApp(context, widget.item);
                      break;
                    case 'share_card':
                      ShareService.shareJewelryCard(context, widget.item);
                      break;
                    case 'copy':
                      ShareService.copyToClipboard(context, widget.item);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'share_whatsapp',
                    child: Row(
                      children: [
                        Icon(Icons.message, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Share to WhatsApp'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share_card',
                    child: Row(
                      children: [
                        Icon(Icons.image, color: Color(0xFFD4AF37)),
                        SizedBox(width: 8),
                        Text('Share Beautiful Card'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Copy Details'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  if (widget.item.imagePath != null) {
                    _showImageZoom(context);
                  }
                },
                child: widget.item.imagePath != null
                    ? Stack(
                        children: [
                          widget.item.imagePath != null && File(widget.item.imagePath!).existsSync()
                              ? Image.file(
                                  File(widget.item.imagePath!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: const CustomLogo(
                                    size: 80,
                                    color: Color(0xFFD4AF37),
                                  ),
                                ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const CustomLogo(
                          size: 80,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Text(
                    widget.item.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.category,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Price and Stock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item.formattedPrice,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.item.isInStock 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.item.isInStock 
                              ? '${widget.item.stockQuantity} in stock'
                              : 'Out of Stock',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.item.isInStock ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  if (widget.item.description.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.item.description,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Melting Data Section (if available)
                  if (widget.item.hasMeltingData) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD4AF37).withOpacity(0.1),
                            const Color(0xFFB8941F).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.scale, color: Color(0xFFD4AF37), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Melting Data',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildMeltingRow('Purity', widget.item.formattedPurity),
                          _buildMeltingRow('Melting Weight', widget.item.formattedMeltingWeight),
                          _buildMeltingRow('Melting Value', widget.item.formattedMeltingValue),
                          if (widget.item.wastagePercentage != null)
                            _buildMeltingRow('Wastage', '${widget.item.wastagePercentage}%'),
                          if (widget.item.makingCharges != null)
                            _buildMeltingRow('Making Charges', widget.item.formattedMakingCharges),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Specifications
                  Text(
                    'Specifications',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSpecRow('Material', widget.item.material),
                  _buildSpecRow('Total Weight', widget.item.formattedWeight),
                  _buildSpecRow('Category', widget.item.category),
                  if (widget.item.brand != null)
                    _buildSpecRow('Brand', widget.item.brand!),
                  if (widget.item.size != null)
                    _buildSpecRow('Size', widget.item.size!),
                  if (widget.item.sku != null)
                    _buildSpecRow('SKU', widget.item.sku!),
                  
                  // Stone Information
                  if (widget.item.stoneCount != null && widget.item.stoneCount! > 0) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Stone Details',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSpecRow('Stone Type', widget.item.stoneType ?? 'N/A'),
                    _buildSpecRow('Stone Count', '${widget.item.stoneCount}'),
                    if (widget.item.stoneWeight != null)
                      _buildSpecRow('Stone Weight', '${widget.item.stoneWeight!.toStringAsFixed(2)}g'),
                  ],
                  
                  // Warranty & Certification
                  if (widget.item.warrantyMonths != null || widget.item.isCertified) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Warranty & Certification',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.item.warrantyMonths != null)
                      _buildSpecRow('Warranty', widget.item.formattedWarranty),
                    if (widget.item.isCertified)
                      _buildSpecRow('Certification', '✓ Certified Authentic'),
                    if (widget.item.isHandmade)
                      _buildSpecRow('Craftsmanship', '✓ Handmade'),
                  ],
                  const SizedBox(height: 24),
                  
                  // Quick Share Buttons
                  QuickShareButtons(item: widget.item),
                  const SizedBox(height: 24),
                  
                  // Quantity Selector
                  if (widget.item.isInStock) ...[
                    Text(
                      'Quantity',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _quantity > 1 
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _quantity.toString(),
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _quantity < widget.item.stockQuantity
                              ? () => setState(() => _quantity++)
                              : null,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.item.isInStock
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '\$${(widget.item.price * _quantity).toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Buttons Row
                  Row(
                    children: [
                      // Share Button
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: () => ShareService.showShareOptions(context, widget.item),
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4AF37),
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Add to Cart Button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isOrdering ? null : _placeOrder,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: _isOrdering
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeltingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4AF37),
            ),
          ),
        ],
      ),
    );
  }
}