const express = require('express');
const router = express.Router();
const {
  getAllCultureInfo,
  getCultureByType,
  createCultureInfo,
  updateCultureInfo,
  deleteCultureInfo,
} = require('../controllers/cultureController');
const { protect, authorize } = require('../middlewares/auth.middleware');

router.get('/', getAllCultureInfo);
router.get('/:type', getCultureByType);

router.post('/', protect, authorize('admin'), createCultureInfo);
router.put('/:id', protect, authorize('admin'), updateCultureInfo);
router.delete('/:id', protect, authorize('admin'), deleteCultureInfo);

module.exports = router;