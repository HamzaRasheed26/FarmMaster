const express =require('express');
const cropRoutes= express.Router();

const cropController=require('../controllers/crop_controller');
const sellcropController=require('../controllers/sellCrop_con');
const crop=require('../models/crop_model');
const app = express();
cropRoutes.post('/crop/create',cropController.createCrop);
cropRoutes.put('/:id',cropController.updateCrop);
cropRoutes.delete('/:id',cropController.deleteCrop);
cropRoutes.get('/api/crops',cropController.getAllCrop);
cropRoutes.get('/sellcrop/get/:id',sellcropController.getSellCrop);
cropRoutes.post('/sellcrop/create',sellcropController.createSellCrop);
cropRoutes.get('/sellcrops',sellcropController.getAllSellCrop);
cropRoutes.delete('/sellcrop/del/:id',sellcropController.deleteCrop);
module.exports=cropRoutes;
