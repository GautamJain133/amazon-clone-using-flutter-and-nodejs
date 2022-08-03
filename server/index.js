
const mongoose = require('mongoose');
const express = require('express')
const authRouter = require("./routes/auth.js");
const adminRouter = require('./routes/admin.js');
const productRouter = require('./routes/product.js');
const userRouter = require('./routes/user.js');


// es port par ham client ki request ko listen krege
const PORT = 9000;
const app = express();
// es link se hame database ka acces mil rha hai
const DB = "mongodb+srv://cluster0.qqghlzn.mongodb.net/?retryWrites=true&w=majority";



//CREATING AN API
// // GET, PUT,POST,DELETE,UPDATE --> CRUD
// middleware 
// CLIENT (FLUTTER) --> middleware --> SERVER --> CLIENT






//The express.json() function is a built-in middleware function in Express.
// It parses incoming requests with JSON payloads and is based on body-parser
app.use(express.json());


// ye app level middleware or router hamne bnaya hai for authentication
app.use(adminRouter);
app.use(authRouter);
app.use(productRouter);
app.use(userRouter);




// here we connect our database with our server
mongoose.connect(DB).then(()=>{
    console.log("connection successfyull");
}).catch((e)=>{
    console.log(e);
});



// here our server starts to listen on the port - PORT
app.listen(PORT,"0.0.0.0",function () {
    console.log(`connectes at port ${PORT}`)
})




