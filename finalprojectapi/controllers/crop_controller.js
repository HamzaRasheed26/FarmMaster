const Crop=require('../models/crop_model')
async function createCrop(req, res){
    try{ 
        const {cropType,plantDate,Quantity,price,weatherCondition,SoilType}=req.body
        const crop= await Crop.create({cropType,plantDate,Quantity,price,weatherCondition,SoilType});
        res.status(201).json({status:true,crop});
    }
    catch(err){
        res.status(500).json({status:false,error: err.message});
    }
}

async function getAllCrop(req, res) {
    try {
        const crops = await Crop.find();
        const cropsDetails = crops.map(crop => ({
            id: crop.id,
            cropType: crop.cropType,
            price: crop.price,
            weatherCondition: crop.weatherCondition,
            SoilType: crop.SoilType,
            plantDate: crop.plantDate,
            Quantity: crop.Quantity
        }));
        return res.status(200).json({ status: true, crops: cropsDetails });
    } catch (err) {
        res.status(500).json({ status: false, error: err.message });
    }
}

async function updateCrop(req, res) {

    try {
        const {id} = req.params;
        const updatedCrop = await Crop.findByIdAndUpdate (id, req.body, { new: true});
        res.json({status:true,updatedCrop});
 } catch (err) {
    
    res.status(500).json({ status:false,error: err.message });
    }
}
async function deleteCrop (req, res) {

    try {
        const {id} = req.params;
        await Crop.findByIdAndDelete(id);
        res.sendStatus (204); 
    } catch (err) {
        res.status(500).json({status:false, error: err.message });
    }
}

module.exports={
    createCrop,
    updateCrop,
    getAllCrop,
    deleteCrop,
};