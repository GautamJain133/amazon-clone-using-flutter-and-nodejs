const express = require('express');
const adminRouter = express.Router();
const admin = require('../middleware/admin');
const {Product} = require('../models/product');
const authRouter = require('./auth');
const Order = require('../models/orders')


// Add product


adminRouter.post('/admin/add-product',admin,async(req,res)=>{
   
   try{


       

    const product_name = req.body.product_name;
    const product_description = req.body.product_description;
    const product_price = req.body.product_price;
    const product_quantity = req.body.product_quantity;
    const product_category = req.body.product_category;
    const product_images = req.body.product_images;

    

    

    let product =  Product({
        product_name,
        product_category,
        product_price,
        product_quantity,
        product_images,
        product_description,
        
       
        
       
    });


    console.log(product);

    product = await product.save();
    
    
    res.json(product);







    


   } 
   catch(e){
    res.status(500).json({error:e.message});
   }
})







//--------------------------------------------------------------------------------------------------------------------------
// api for getting the product


adminRouter.get('/admin/get-products',admin,async(req,res)=>{

try{
const products = await Product.find({});
res.json(products);
}
catch(e){
    res.status(500).json({error:e.message});
}


});


//---------------------------------------------------------------------------------------------------------------------------------------------------
 
// api to delete the product

authRouter.post('/admin/delete-product',admin,async (req,res)=>{

   try{
                                        
    const id = req.body.id;
     let product =  await Product.findByIdAndDelete(id);
    res.json(product);

   }
   catch(e){
    console.log('error');
    res.status(500).json({error:e.message});
   }

})




adminRouter.get('/admin/get-orders',admin,async(req,res)=>{
    try{
  

     const orders = await Order.find({})
     res.json(orders);


    }
    catch(e){
    
    res.status(500).json({error:e.message});  
    }
})





authRouter.post('/admin/change-order-status',admin,async (req,res)=>{

    try{
                                         
     const id = req.body.id;
     const status = req.body.status;
      let order =  await Order.findById(id);

order.status = status;
order = await order.save();
     res.json(order);
 
    }
    catch(e){
     
     res.status(500).json({error:e.message});
    }
  
 
 
 
 
 
 })







adminRouter.get('/admin/analytics',admin,async(req,res)=>{

try{

const orders = await Order.find({});
let totalEarnings = 0;

for(let i =0;i<orders.length;i++){
    for(let j =0;j<orders[i].products.length;j++){

        totalEarnings += 
        orders[i].products[j].quantity * orders[i].products[j].product.product_price;

    }
}
//console.log('total earnnig '+totalEarnings);


// CATEGORYWISE ORDER FETCHING

let mobileEarnings = await fetchCategoryWiseProduct('Mobiles');
let essentialsEarnings = await fetchCategoryWiseProduct('Essentials');
let applianceEarnings = await fetchCategoryWiseProduct('Appliances');
let booksEarnings =    await fetchCategoryWiseProduct('Books');
let fashionEarnings = await fetchCategoryWiseProduct('Fashion');


let earnings = {
    totalEarnings,
    mobileEarnings,
    essentialsEarnings,
    applianceEarnings,
    booksEarnings,
    fashionEarnings,
}

res.json(earnings);

}
catch(e){
    res.status(500).json({error:e.message}); 
}








});




async function fetchCategoryWiseProduct(category){
    
   let categoryOrders = await Order.find({'products.product.product_category':category});
   
let earnings = 0;

for(let i =0;i<categoryOrders.length;i++){
    for(let j =0;j<categoryOrders[i].products.length;j++){

        earnings += 
        categoryOrders[i].products[j].quantity * categoryOrders[i].products[j].product.product_price;

    }
}

return earnings;
}















module.exports = adminRouter;