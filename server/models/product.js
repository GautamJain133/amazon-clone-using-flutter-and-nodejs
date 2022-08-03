const mongoose = require('mongoose');
const ratingSchema = require('./rating.js');





const productSchema = new mongoose.Schema({
    product_name:{
        require:true,
        type:String,
        trim:true,
    },

    product_category:{
        require:true,
        type:String,
        trim: true,
        },
    

        
    product_price:{
    required:true,
             
    type: Number,

        },

        product_quantity:{
            required:true ,
            type: Number,
            
        },

        product_images:[{
         
            required:true ,
            type: String,
            
        }],

        product_description:{
            required: true,
            type: String,
            trim: true,
        },


      ratings:[ratingSchema],

    });

const Product = mongoose.model("Product",productSchema);

module.exports ={Product,productSchema};