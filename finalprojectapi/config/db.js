const mongoose = require('mongoose');
mongoose.set('strictQuery',true);

mongoose.connect('mongodb://127.0.0.1:27017/FinalProject-apis',{
    useNewUrlParser:true,
    useUnifiedTopology:true,
});

const db = mongoose.connection;
db.on('error',(err)=>{
    console.log('failed connection with db');
});
db.once('open',()=>{
    console.log('connection with db');
});