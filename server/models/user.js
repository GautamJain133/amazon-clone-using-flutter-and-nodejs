const mongoose = require('mongoose');
const { productSchema } = require('./product');


const userSchema = new mongoose.Schema({
    username: {
        require: true,
        type: String,
        trim: true,
    },

    useremail: {
        require: { type: true },
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re =
                    /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);


            },
            message: 'please enter the valid email address'
        },
    },

        
    userpassword: {
        required: { type: true },
        type: String,

        // validate:{
        //     validator:(value)=>{
        //      return value.length>6;

        //     },
        //     message:'please enter a long password'
        // },
    },

    useraddress: {
        
        type: String,
        default: 'blablabla'
    },

    type: {
         
             
        type: String,
        default: 'user',
    },


    cart: [

        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true,
            }
        }
        
    ]




});




const User = mongoose.model("User",userSchema);

module.exports = User;