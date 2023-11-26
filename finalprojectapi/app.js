const express = require('express');
const bodyParser=require('body-parser');
const userRouter=require('./routes/user_routes');
const cropRouter=require('./routes/crop_routes');
const emailRouter=require('./routes/email_routes');
const app = express();

app.use(bodyParser.json());
app.use('/',userRouter);
app.use('/',emailRouter);
app.use('/',cropRouter);
module.exports=app;