const router=require('express').Router();
const EmailController=require('../controllers/email_controller');
router.post('/email',EmailController.createEmail);
router.delete('/:id',EmailController.deleteEmail);
router.get('/api/emails',EmailController.getAllemails);
module.exports=router;
