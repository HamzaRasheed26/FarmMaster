const UserModel=require('../models/user_model')
class UserService{
    static async registerUser(firstName,lastName,password,email,role){
        try{
            const createUser=new UserModel({firstName,lastName,password,email,role});
            return await createUser.save();
        }
        catch(err){
            throw err;
        }
    }

}
module.exports=UserService;