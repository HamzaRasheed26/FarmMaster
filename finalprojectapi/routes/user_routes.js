const router=require('express').Router();
const UserController=require('../controllers/user_controller');
router.post('/registration',UserController.register);
router.post('/login',UserController.login);
router.get('/users',UserController.getAllUsers);
router.put('/update/user/:id',UserController.updateUser);
router.delete('/delete/user/:id',UserController.deleteUser);
module.exports=router;
