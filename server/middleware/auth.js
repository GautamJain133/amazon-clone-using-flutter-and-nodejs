const jwt = require('jsonwebtoken');

const auth = async(req,res,next)=>{
    try{
       
        const token = req.header("x-auth-token");
        console.log('token : '+ token);
        
        if(!token)
        return res.status(401).json({msg:"no auth token, access denied"});

        const verified = jwt.verify(token,"passwordKey");
        

        if(!verified)
        return res.status(401).json({msg:"token verification failed, authorization denied"});

       // request me hamko ek req.user milta hai ham usme verified.id se id dal denge taki hame body me id bhejni hi na pde
        req.user = verified.id; // ab ham jb call back funtion likhege to wha pr req.user karne se hamko directly user ki id mil jayegi
        next();
        
    }
    catch(err){
        console.log('error in middleware');
        res.status(500).json({error:err.message});
    }
}
module.exports = auth;