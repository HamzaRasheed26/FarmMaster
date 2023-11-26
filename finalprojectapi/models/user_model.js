const mongoose= require('mongoose');
const db =require('../config/db');
const {Schema} =mongoose;
const userSchema = new Schema({
    firstName:{
        type:String,
        required:true,
    },
    lastName:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        lowercase:true,
        required:true,
        unique:true
    },
    password:{
        type:String,
        lowercase:true,
        required:true,
        unique:true
    },
    role:{
        type:String,
        required:true
    }

}, { timestamps: true});
module.exports=mongoose.model('user', userSchema);