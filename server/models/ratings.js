const mongoose = require("mongoose");

const ratingScheme = mongoose.Schema({
    userId: {
        required: true,
        type: String,
    },
    rating: {
        required: true,
        type: Number,
    }
});

module.exports = ratingScheme;