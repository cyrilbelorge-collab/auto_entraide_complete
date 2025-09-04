const router = require('express').Router();
const ctrl = require('../controllers/dtcController');

router.get('/', ctrl.list);
router.get('/:code', ctrl.get);

module.exports = router;