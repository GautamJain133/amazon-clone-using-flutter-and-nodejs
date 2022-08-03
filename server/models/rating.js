
const ratingSchema = {
    userId:{
        type:  String,
        required: true,
    },

    rating:{
        type:Number,
        required:true,
    }
};
 module.export = ratingSchema;