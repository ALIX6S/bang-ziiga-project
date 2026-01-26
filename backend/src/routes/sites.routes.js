const express = require('express');
const router = express.Router();
const {
  getAllSites,
  getFeaturedSites,
  getSiteById,
  createSite,
  updateSite,
  deleteSite,
} = require('../controllers/sitesController');
const { protect, authorize } = require('../middlewares/auth.middleware');

router.get('/', getAllSites);
router.get('/featured', getFeaturedSites);
router.get('/:id', getSiteById);

router.post('/', protect, authorize('admin'), createSite);
router.put('/:id', protect, authorize('admin'), updateSite);
router.delete('/:id', protect, authorize('admin'), deleteSite);

module.exports = router;