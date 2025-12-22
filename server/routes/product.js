const express = require("express");
const auth = require("../middlewares/auth_middle");
const { Product } = require("../models/product");

const produtRouter = express.Router();

produtRouter.get("/api/products", auth, async (req, res) => {
    try {
        console.log(req.query.category);
        const product = await Product.find({ category: req.query.category });
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

produtRouter.get("/api/products/search/:productName", auth, async (req, res) => {
    try {
        console.log(req.params.productName);
        const product = await Product.find({
            productName: { $regex: req.params.productName, $options: "i" },
        });
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

produtRouter.post("/api/product-ratings", auth, async (req, res) => {
    try {
        const { id, rating } = req.body;
        let product = await Product.findById(id);

        for (let i = 0; i < product.ratings.length; i++) {
            if (product.ratings[i].userId == req.user) {
                product.ratings.splice(i, 1);
                break;
            }
        }

        const ratingScheme = {
            userId: req.user,
            rating: rating,
        }

        product.ratings.push(ratingScheme);
        product = await product.save();
        res.json(product);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

produtRouter.get("/api/deal-of-day", auth, async (req, res) => {
    try {
        let products = await Product.find({});
        if (!products.length) return res.status(200).json(null);
        products.sort((a, b) => {
            const aRatings = a.ratings || [];
            const bRatings = b.ratings || [];

            const aAvg = aRatings.reduce((s, r) => s + r.rating, 0) / (aRatings.length || 1);
            const bAvg = bRatings.reduce((s, r) => s + r.rating, 0) / (bRatings.length || 1);

            const aScore = aAvg * Math.log(aRatings.length + 1);
            const bScore = bAvg * Math.log(bRatings.length + 1);

            return bScore - aScore;
        });
        res.json(products[0]);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// produtRouter.get("/api/deal-of-day", auth, async (req, res) => {
//     try {
//         let products = await Product.find({});
//         products = products.sort((a, b) => {
//             let aSum = 0;
//             let bSum = 0;
//             for (let i = 0; i < a.ratings.length; i++) {
//                 aSum += a.ratings[i].rating;
//             }
//             for (let i = 0; i < b.ratings.length; i++) {
//                 bSum += b.ratings[i].rating;
//             }
//             return aSum < bSum ? 1 : -1
//         });
//         res.json(products[0]);
//     } catch (e) {
//         res.status(500).json({ error: e.message });
//     }
// });


module.exports = produtRouter;