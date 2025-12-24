const express = require('express');
const { FirebaseService } = require('../services/firebase');
const router = express.Router();

// Place order
router.post('/', async (req, res) => {
  try {
    const { user_id, jewelry_id, quantity } = req.body;
    
    // Get jewelry item details
    const itemDoc = await FirebaseService.jewelryItems().doc(jewelry_id).get();
    if (!itemDoc.exists) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    const item = FirebaseService.docToObject(itemDoc);
    
    // Check stock
    if (item.stock_quantity < quantity) {
      return res.status(400).json({ error: 'Insufficient stock' });
    }
    
    const total_price = item.price * quantity;
    
    // Create order
    const orderData = {
      user_id,
      jewelry_id,
      quantity: parseInt(quantity),
      total_price,
      status: 'pending',
      created_at: FirebaseService.serverTimestamp()
    };
    
    const orderRef = await FirebaseService.orders().add(orderData);
    
    // Update stock
    await FirebaseService.jewelryItems().doc(jewelry_id).update({
      stock_quantity: item.stock_quantity - quantity
    });
    
    res.json({
      success: true,
      message: 'Order placed successfully!',
      order_id: orderRef.id
    });
  } catch (error) {
    console.error('Error placing order:', error);
    res.status(500).json({ error: 'Failed to place order' });
  }
});

// Get orders
router.get('/', async (req, res) => {
  try {
    const { user_id } = req.query;
    
    let ordersQuery = FirebaseService.orders().orderBy('created_at', 'desc');
    
    // If user_id provided, filter by user
    if (user_id) {
      ordersQuery = ordersQuery.where('user_id', '==', user_id);
    }
    
    const ordersSnapshot = await ordersQuery.get();
    const orders = FirebaseService.queryToArray(ordersSnapshot);
    
    // Get jewelry item details for each order
    for (let order of orders) {
      try {
        const itemDoc = await FirebaseService.jewelryItems().doc(order.jewelry_id).get();
        if (itemDoc.exists) {
          order.jewelry_item = FirebaseService.docToObject(itemDoc);
        }
      } catch (error) {
        console.error('Error fetching jewelry item for order:', error);
      }
    }
    
    res.json(orders);
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update order status
router.put('/:id/status', async (req, res) => {
  try {
    const orderId = req.params.id;
    const { status } = req.body;
    
    await FirebaseService.orders().doc(orderId).update({
      status,
      updated_at: FirebaseService.serverTimestamp()
    });
    
    res.json({ success: true, message: 'Order status updated successfully!' });
  } catch (error) {
    console.error('Error updating order status:', error);
    res.status(500).json({ error: 'Failed to update order status' });
  }
});

module.exports = router;