const UserService=require('../services/user_services')
const User=require('../models/user_model')
async function register(req, res, next) {
    try {
        const { firstName, lastName, password, email, role } = req.body;

        // Check if the email already exists in the database
        const existingEmail = await User.findOne({email});
        if (existingEmail) {
            return res.status(400).json({ status: false, error: "Email already exists" });
        }

        // Check if the password is already in use (this depends on your specific logic)
        const existingPassword = await User.findOne({password});
        if (existingPassword) {
            return res.status(400).json({ status: false, error: "Password already in use" });
        }

        // If email and password are not already in use, proceed with user registration
        const successRes = await UserService.registerUser(firstName, lastName, password, email, role);
        res.json({ status: true, success: "User Registered Successfully" });
    } catch (err) {
        // Handle other errors
        console.error(err);
        res.status(500).json({ status: false, error: "An error occurred during registration" });
    }
}
async function login(req,res,next){
    try{
        const { email, password } = req.body;
    
        try {
            const user = await User.findOne({ email });
        
            if (!user) return res.status(404).json({ status:false,error: 'User not found' });
        
            if (user.password!=password) return res.status(401).json({ status:false, error: 'Invalid credentials' });
        
            var token = GenerateToken(user);
            var Role=user.role;
        
            return res.status(200).json({
        
                message: 'Logged in successfully',
                status:true,
                email:user.email,
                password:user.password,
                role:Role,
                userid: user.id,
                token: token,
             });
        
        } catch (err) {
        
        return res.status(500).json({ message: err });
        
        }
    }
    catch(err){
        throw err;
    }
}
async function getAllUsers(req, res) {
    try {
        const farmers = await User.find({ role: 'Farmer' });
        const farmersDetails = farmers.map(farmer => ({
            id: farmer.id,
            firstName: farmer.firstName,
            lastName: farmer.lastName,
            email: farmer.email,
            password: farmer.password,
            role: farmer.role,
        }));
        return res.status(200).json({ status: true, users: farmersDetails });
    } catch (err) {
        res.status(500).json({ status: false, error: err.message });
    }
}

async function updateUser(req, res) {

    try {
        const {id} = req.params;
        const updatedUser = await User.findByIdAndUpdate (id, req.body, { new: true});
        res.json({status:true,updateUser});
 } catch (err) {
    
    res.status(500).json({ status:false,error: err.message });
    }
}
async function deleteUser (req, res) {

    try {
        const {id} = req.params;
        await User.findByIdAndDelete(id);
        res.sendStatus (204); 
    } catch (err) {
        res.status(500).json({status:false, error: err.message });
    }
}

module.exports={
    register,
    login,
    updateUser,
    deleteUser,
    getAllUsers,
}
const jwt = require('jsonwebtoken'); 
const { use } = require('../routes/email_routes');

function GenerateToken(user) {
    const payload = {
        role: user.role,
        id: user._id,
    };
    const token = jwt.sign(payload, 'abababababab.adsfxc');
    return token;

};

