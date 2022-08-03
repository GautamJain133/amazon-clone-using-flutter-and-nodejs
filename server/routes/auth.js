const express = require("express");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require('jsonwebtoken')

const User = require("../models/user")  // ye rha mongoose k model ko import kar rhe hai eske through ham kuch database functionality ko access krege
const auth = require("../middleware/auth");


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// api for signup
// 1. get the data from the user;
// 2. check if the user is already exists or not
// 3. hash the user password;
// 4. post the data on database;
// 5. return response to the user;
authRouter.post("/api/signup",async(req,res)=>{
   try{

 const username = req.body.username;   // for signup user sent user name , email and password in the request
 const useremail = req.body.useremail;
 const userpassword = req.body.userpassword;

 
 const existingUser = await User.findOne({useremail}); // database me check kiya ki particular email ka user pehle se exist karta hai kya



 // agar given email ka user pehle se exist karta hai to ham message send kr denge ki user with this email is already 
 // exists no need to signup please signin directly
 if(existingUser){
  return res.status(400).json({msg: 'User with same email already exixts'});
 }

  // yha pr hamne hamare password ko hash kiya or fir ham usko database pr bhejege taki vo secure rhe
 const hashedPassword = (await bcryptjs.hash(userpassword,8)).toString();
 console.log(`hashed password ${hashedPassword}`);


  
 // ye yha pr data ko hamne uske schema k ander dal diya ab ye data ready hai databse pr save krne k liye
 let user = User({
     username,
     useremail,
    userpassword:hashedPassword,

 })

 // ye yha pr hamne user k data ko database pr save kar diya
 user = await user.save();

 // client request me same data with hashed password k sath response me send kar diya
 res.json(user);

   }
   catch(e){
      console.log(e.message);
        res.status(500).json({error:e.message});
   }
});

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------









//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// api for signin
// 1. get the data from user
// 2. check if user is not already exist or exist
// 3. if user exist then check the user entered the correct password or not using bcrypt js
// 4. if user entered wrong password the sent message Incorrect passord
// 5. now generate the token using the jwt webtoken
// 6. send the token along with the user info to the client

authRouter.post("/api/signin",async(req,res)=>{
   try{
     
      // 1. get the data from user
      const email = req.body.useremail;
      const password = req.body.userpassword;


      // 2. check if user is not already exist or exist
      const user = await User.findOne({useremail:email});
      if(!user){
      return res.status(400).json({msg: "useer with this email not exist"})
      }
      
         
      // 3. if user exist then check the user entered the correct password or not using bcrypt js
      const isMatch =   bcryptjs.compare(password,user.userpassword);

        
      // 4. if user entered wrong password the sent message Incorrect passord
      if(!isMatch){
      return res.status(400).json({msg: "Incorrect password"});
      }

      // 5. now generate the token using the jwt webtoken 
      const token =  jwt.sign({id:user._id},"passwordKey");
      
      // 6. send the token along with the user info to the client taki user es token ko app memory me save kr sake
      res.json({token,...user._doc});

          
   }
   catch(e){
      console.log(e.message);
        res.status(500).json({error:e.message}); 
   }
})
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// check token valid or not

authRouter.post('/tokenIsValid',async(req,res)=>{
    try{
      
      // yha pr shareprefeences wala token hamko request k header me mila hai
      const token = req.header('x-auth-token');

   
      
      // token null milta hai to ham response me false send kardenge
      if(!token){
         return res.json(false);
      }



   // ab agr hamare pass token hai to hamko eeseee verify karna hoga ki yeh sahi hai ya nhi
   const verified = jwt.verify(token,'passwordKey');


       
   // agr verified nhi hai to h am yha se response me false send kardege
   if(!verified)return res.json(false);


   // ab ye bhi ho skta hai ki hamara user exist hi nhi karta hai or jwt usse verify krde to ham jwt k dwara di gyi id se check krege kivo user hamare database me hai ya nhi
   const user = await User.findById(verified.id);

      

      // now if again the user doesn't exists
      if(!user) return res.json(false);


      // ab agr sb kuch sahi hai to 
      return res.json(true);

    }
    catch(e){
      console.log('inside catch');
     res.status(500).json({error:e.message});

    }
});

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// getting the user data 

// here auth is the middleware this make sure that you are authorised that means you only have the capability to access this route if tou are signed in
authRouter.get('/',auth,async(req,res)=>{

// first we find the user in our database by id  
const user = await User.findById(req.user);

// now we send the user data along with the user token  
res.json({ ...user._doc,token: req.header("x-auth-token")});
  

});

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



module.exports = authRouter

