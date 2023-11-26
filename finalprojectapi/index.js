const app = require('./app');
const db = require('./config/db');
const port = 3700;
app.get('/', (req,res)=>{
    res.send('Hello world');
});
app.listen(port,()=>{
    console.log('Server is listening on port'  + port);
});