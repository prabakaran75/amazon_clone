const mongoose = require("mongoose");
const ratingScheme = require("./ratings");

const productSchema = mongoose.Schema({
    images: [
        {
            required: true,
            type: String,
        },
    ],
    productName: {
        required: true,
        type: String,
        trim: true,
    },
    description: {
        required: true,
        type: String,
    },
    price: {
        required: true,
        type: Number,
    },
    qty: {
        required: true,
        type: Number,
    },
    category: {
        required: true,
        type: String
    },
    ratings: [ratingScheme],
});

const Product = mongoose.model("Product", productSchema);
module.exports = { Product, productSchema };