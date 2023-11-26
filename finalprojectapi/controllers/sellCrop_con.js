const SellCrop=require('../models/sellCrop_model')
const Crop=require('../models/crop_model')
async function getSellCrop(req, res){
    try{ 
        const {id} = req.params;
        const crop = await Crop.findById(id);
        if (!crop) {
            return res.status(404).json({ status: false, error: 'Crop not found' });
        }

        const sellCropDetails = {
            id: crop.id,
            cropType: crop.cropType,
            price: crop.price,
            weatherCondition: crop.weatherCondition,
            SoilType: crop.SoilType,
            plantDate: crop.plantDate,
            Quantity: crop.Quantity
        };

        return res.status(200).json({ status: true, crops: sellCropDetails });
    }
    catch(err){
        res.status(500).json({ status: false, error: err.message });
    }
}

async function createSellCrop(req, res) {
    try {
        const { cropType, plantDate, Quantity, price, weatherCondition, SoilType } = req.body;
        // Check if a similar sellCrop already exists based on specific fields (e.g., cropType)
        const existingCrop = await SellCrop.findOne({ cropType });

        if (existingCrop) {
            return res.status(400).json({ status: false, error: 'already exists' });
        }

        const sellCrop = await SellCrop.create({ cropType, plantDate, Quantity, price, weatherCondition, SoilType });
        res.status(201).json({ status: true, sellCrop });
    } catch (err) {
        res.status(500).json({ status: false, error: err.message });
    }
}
async function deleteCrop (req, res) {

    try {
        const {id} = req.params;
        await SellCrop.findByIdAndDelete(id);
        res.sendStatus(204); 
    } catch (err) {
        res.status(500).json({status:false, error: err.message });
    }
}
function compareObjects(obj1, obj2) {
    // Function to compare specific fields of objects
    const keysToCompare = ['cropType', 'SoilType', 'Quantity', 'price'];

    for (let key of keysToCompare) {
        if (obj1[key] !== obj2[key]) {
            return false;
        }
    }

    return true;
}
async function getAllSellCrop(req, res) {
    try {
        const sellCrops = await SellCrop.find();
        const crops = await Crop.find();

        const validSellCrops = sellCrops.filter(sellCrop =>
            crops.some(crop => compareObjects(crop.toObject(), sellCrop.toObject()))
        );

        const invalidSellCrops = sellCrops.filter(sellCrop =>
            !crops.some(crop => compareObjects(crop.toObject(), sellCrop.toObject()))
        );

        if (invalidSellCrops.length > 0) {
            await Promise.all(
                invalidSellCrops.map(async invalidSellCrop =>
                    SellCrop.findByIdAndDelete(invalidSellCrop.id)
                )
            );
            console.log('Some invalid sell crops were deleted.');
        }

        const cropsDetails = validSellCrops.map(sellCrop => ({
            id: sellCrop.id,
            cropType: sellCrop.cropType,
            price: sellCrop.price,
            weatherCondition: sellCrop.weatherCondition,
            SoilType: sellCrop.SoilType,
            plantDate: sellCrop.plantDate,
            Quantity: sellCrop.Quantity
        }));

        return res.status(200).json({ status: true, crops: cropsDetails });
    } catch (err) {
        res.status(500).json({ status: false, error: err.message });
    }
}
module.exports={
    getSellCrop,
    createSellCrop,
    getAllSellCrop,
    deleteCrop,
    compareObjects,
};