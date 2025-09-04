const router = require('express').Router();
const auth = require('../middleware/auth');
const ctrl = require('../controllers/problemController');

router.get('/', auth.optionalAuth, ctrl.list);
router.post('/', auth.optionalAuth, ctrl.create);
router.get('/:id', ctrl.get);

module.exports = router;