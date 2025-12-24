const express = require('express');
const { FirebaseService } = require('../services/firebase');
const router = express.Router();

// Get all jewelry items
router.get('/', async (req, res) => {
  try {
    const itemsSnapshot = await FirebaseService.jewelryItems()
      .orderBy('created_at', 'desc')
      .get();
    
    const items = FirebaseService.queryToArray(itemsSnapshot);
    res.json(items);
  } catch (error) {
    console.error('Error fetching jewelry items:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Search jewelry items
router.get('/search', async (req, res) => {
  const { q } = req.query;
  
  if (!q || q.trim().length === 0) {
    return res.status(400).json({ error: 'Search query is required' });
  }
  
  try {
    const searchTerm = q.trim().toLowerCase();
    
    // Get all items and filter client-side (Firestore doesn't support complex text search)
    const itemsSnapshot = await FirebaseService.jewelryItems().get();
    const allItems = FirebaseService.queryToArray(itemsSnapshot);
    
    const filteredItems = allItems.filter(item => {
      return (
        item.name?.toLowerCase().includes(searchTerm) ||
        item.sku?.toLowerCase().includes(searchTerm) ||
        item.category?.toLowerCase().includes(searchTerm) ||
        item.material?.toLowerCase().includes(searchTerm) ||
        item.description?.toLowerCase().includes(searchTerm) ||
        item.brand?.toLowerCase().includes(searchTerm)
      );
    });
    
    // Sort by relevance (name matches first)
    filteredItems.sort((a, b) => {
      const aNameMatch = a.name?.toLowerCase().includes(searchTerm) ? 1 : 0;
      const bNameMatch = b.name?.toLowerCase().includes(searchTerm) ? 1 : 0;
      return bNameMatch - aNameMatch;
    });
    
    res.json({
      items: filteredItems,
      count: filteredItems.length,
      query: q
    });
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ error: 'Search failed' });
  }
});

// Add new jewelry item
router.post('/', async (req, res) => {
  try {
    const {
      name, description, price, category, material, weight, stock_quantity,
      purity, karat, melting_weight, melting_value, wastage_percentage, making_charges,
      brand, size, color, gender, certification, supplier, purchase_price, margin_percentage,
      sku
    } = req.body;

    // Generate SKU if not provided
    const generatedSku = sku || await FirebaseService.generateSKU(category || 'GEN', material || 'GEN');

    const itemData = {
      name: name || 'Unnamed Item',
      description: description || '',
      price: parseFloat(price) || 0,
      category: category || 'Uncategorized',
      material: material || 'Unknown',
      weight: parseFloat(weight) || 0,
      image_url: req.file ? `/uploads/${req.file.filename}` : '',
      stock_quantity: parseInt(stock_quantity) || 0,
      sku: generatedSku,
      
      // Melting data
      purity: purity || '22K',
      karat: parseInt(karat) || 22,
      melting_weight: parseFloat(melting_weight) || 0,
      melting_value: parseFloat(melting_value) || 0,
      wastage_percentage: parseFloat(wastage_percentage) || 8,
      making_charges: parseFloat(making_charges) || 0,
      
      // Business data
      brand: brand || 'Ambabai Jewellers',
      size: size || 'Standard',
      color: color || 'Gold',
      gender: gender || 'Unisex',
      certification: certification || 'BIS Hallmark',
      supplier: supplier || 'Local Supplier',
      purchase_price: parseFloat(purchase_price) || 0,
      margin_percentage: parseFloat(margin_percentage) || 20,
      
      created_at: FirebaseService.serverTimestamp()
    };

    const docRef = await FirebaseService.jewelryItems().add(itemData);
    
    res.json({
      success: true,
      message: 'Jewelry item added successfully!',
      id: docRef.id,
      item: { id: docRef.id, ...itemData }
    });
  } catch (error) {
    console.error('Error adding jewelry item:', error);
    res.status(500).json({ error: 'Failed to add jewelry item' });
  }
});

// Delete jewelry item
router.delete('/:id', async (req, res) => {
  try {
    const itemId = req.params.id;
    
    // Check if item exists
    const itemDoc = await FirebaseService.jewelryItems().doc(itemId).get();
    if (!itemDoc.exists) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    // Delete the item
    await FirebaseService.jewelryItems().doc(itemId).delete();
    
    res.json({ success: true, message: 'Jewelry item deleted successfully!' });
  } catch (error) {
    console.error('Error deleting jewelry item:', error);
    res.status(500).json({ error: 'Failed to delete jewelry item' });
  }
});

// Update jewelry item
router.put('/:id', async (req, res) => {
  try {
    const itemId = req.params.id;
    const updateData = { ...req.body };
    
    // Remove undefined values
    Object.keys(updateData).forEach(key => {
      if (updateData[key] === undefined) {
        delete updateData[key];
      }
    });
    
    // Add updated timestamp
    updateData.updated_at = FirebaseService.serverTimestamp();
    
    await FirebaseService.jewelryItems().doc(itemId).update(updateData);
    
    res.json({ success: true, message: 'Jewelry item updated successfully!' });
  } catch (error) {
    console.error('Error updating jewelry item:', error);
    res.status(500).json({ error: 'Failed to update jewelry item' });
  }
});

module.exports = router;