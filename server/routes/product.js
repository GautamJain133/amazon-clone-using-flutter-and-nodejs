



const express = require('express');
const productRouter = express.Router();
const auth = require('../middleware/auth');
const {Product} = require('../models/product');


// api/products?category=Essentials
productRouter.get('/api/products',auth,async(req,res)=>{

    try{

        console.log(req.query.category);

    const products = await Product.find({product_category:req.query.category });




    res.json(products);
    }
    catch(e){
        res.status(500).json({error:e.message});
    }
    
    
    });



  // api for search product


  productRouter.get('/user/products/search/:name',auth,async(req,res)=>{

    try{

    console.log(req.params.name);
    const products = await Product.find({product_name:{$regex: req.params.name,$options: "i"} });


   console.log(products);

    res.json(products);
    }
    catch(e){
        res.status(500).json({error:e.message});
    }
    
    
    });





 
// create the post request route to rate teh product

   productRouter.post('/api/rate-product',auth,async(req,res)=>{

   try{

        const rateSchema= {
            userId : req.user,
            rating : req.body.rating
        };


      console.log('product id'+ req.body.id);  

      let product = await Product.findById(req.body.id);

      console.log('product '+ product);  


    

      for(let i =0;i<product.ratings.length;i++){
           console.log(product.ratings[i].userId);
          if(product.ratings[i].userId == req.user){
                product.ratings.splice(i,1);
                break;
          } 
      }


    console.log('after foorloop');



    product.ratings.push(rateSchema)
    product = await product.save();
    res.json(product);
    
    
   }
   catch(e){
    console.log('error');
   res.status(500).json({error:e.message});
   }

   });


  // deal of the day




  productRouter.get('/api/deal-of-day',auth,async(req,res)=>{

    try{

      
    let product = await Product.find({});
    // let productRes;
    // let max = -1;

    // for(let i =0;i<product.length;i++){
        
    //     let totalRating=0;
    //     for(let j =0;i<product[i].ratings.length;j++){
    //     totalRating+=product[i].ratings[j].rating;
    //     }
        
    //     if(max<totalRating){
    //         max = totalRating;
    //         productRes = product[i];
    //     }

    // }

    let dealProduct = product.sort((prod1,prod2)=>{
      let prod1sum =0;
      let prod2sum =0;
      for(let i =0;i<prod1.ratings.length;i++){
        prod1sum+=prod1.ratings[i].rating;
      }

      for(let i =0;i<prod2.ratings.length;i++){
        prod2sum+=prod2.ratings[i].rating;
      }

      return prod1sum<prod2sum ? 1:-1;




    });









   console.log(`deal of the day deal ${dealProduct[0]}`);

    res.json(dealProduct[0]);
    }
    catch(e){
        res.status(500).json({error:e.message});
    }
    
    
    });














    module.exports = productRouter;