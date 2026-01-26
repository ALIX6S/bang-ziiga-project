const express = require('express');
const router = express.Router();
const {
  getAllItineraires,
  getItineraireById,
  createItineraire,
  updateItineraire,
  deleteItineraire,
} = require('../controllers/itinerairesController');
const { protect, authorize } = require('../middlewares/auth.middleware');

router.get('/', getAllItineraires);
router.get('/:id', getItineraireById);

router.post('/', protect, authorize('admin'), createItineraire);
router.put('/:id', protect, authorize('admin'), updateItineraire);
router.delete('/:id', protect, authorize('admin'), deleteItineraire);

module.exports = router;