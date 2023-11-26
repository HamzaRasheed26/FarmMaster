const mongoose= require('mongoose');
const db =require('../config/db');
const {Schema} =mongoose;
const sellCropSchema = new Schema({
    cropType:{
        type:String,
        required:true
    },
    plantDate:{
        type:Date,
        required:true,
    },
    Quantity:{
        type:Number,
        required:true
    },
    price:{
        type:Number,
        required:true
    },
    weatherCondition:{
        type:String,
        required:true
    },
    SoilType:{
        type:String,
        required:true
    }

}, { timestamps: true});
module.exports=mongoose.model('sellCrop', sellCropSchema);