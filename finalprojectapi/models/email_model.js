const mongoose= require('mongoose');
const db =require('../config/db');
const {Schema} =mongoose;
const emailSchema = new Schema({
    Name:{
        type:String,
        required:true,
    },
    Subject:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        lowercase:true,
        required:true,
    },
    msg:{
        type:String,
        required:true
    }

}, { timestamps: true});
module.exports=mongoose.model('email', emailSchema);