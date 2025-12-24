const express = require('express');
const { FirebaseService } = require('../services/firebase');
const router = express.Router();

// Get all users (admin only)
router.get('/', async (req, res) => {
  try {
    const usersSnapshot = await FirebaseService.users()
      .orderBy('created_at', 'desc')
      .get();
    
    const users = FirebaseService.queryToArray(usersSnapshot);
    
    // Remove passwords from response
    users.forEach(user => delete user.password);
    
    res.json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Delete user (admin only)
router.delete('/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    
    // Get user info before deletion for notification
    const userDoc = await FirebaseService.users().doc(userId).get();
    if (!userDoc.exists) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    const user = FirebaseService.docToObject(userDoc);
    
    // Delete the user
    await FirebaseService.users().doc(userId).delete();
    
    res.json({ success: true, message: 'User deleted successfully!' });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ error: 'Failed to delete user' });
  }
});

// Get user profile
router.get('/profile/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    
    const userDoc = await FirebaseService.users().doc(userId).get();
    if (!userDoc.exists) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    const user = FirebaseService.docToObject(userDoc);
    delete user.password; // Remove password from response
    
    res.json(user);
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update user profile
router.put('/profile/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const { name, email, phone, address } = req.body;
    
    const updateData = {
      name,
      email,
      phone,
      address,
      updated_at: FirebaseService.serverTimestamp()
    };
    
    // Remove undefined values
    Object.keys(updateData).forEach(key => {
      if (updateData[key] === undefined) {
        delete updateData[key];
      }
    });
    
    await FirebaseService.users().doc(userId).update(updateData);
    
    res.json({ success: true, message: 'Profile updated successfully!' });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

module.exports = router;