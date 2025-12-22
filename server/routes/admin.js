const express = require("express");
const admin = require("../middlewares/admin_middle");
const { Product } = require("../models/product");
const Order = require("../models/order");
const adminRouter = express.Router();

//Add-Product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
    try {
        const { images, productName, description, price, qty, category } = req.body;
        let product = new Product({
            images,
            productName,
            description,
            price,
            qty,
            category,
        });
        product = await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Get All Product
adminRouter.get("/admin/get-products", admin, async (req, res) => {
    try {
        const products = await Product.find({});
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Delete the product
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
    try {
        const { id } = req.body;
        let product = await Product.findByIdAndDelete(id);
        if (!product) {
            return res.status(404).json({ msg: "Product not found" });
        }
        res.send("Product deleted successfully");
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Get all Orders
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
    try {
        const order = await Order.find({});
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Change status
adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
    try {
        const { id, status } = req.body;
        let order = await Order.findById(id);
        order.status = status;
        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Analytics
adminRouter.get("/admin/analytics", admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        let totalEarning = 0;

        for (let i = 0; i < orders.length; i++) {
            for (let j = 0; j < orders[i].products.length; j++) {
                totalEarning += orders[i].products[j].quantity * orders[i].products[j].product.price;
            }
        }

        //Category Wise Order Fetching
        let mobileEarnings = await fetchCategoryProduct("Mobiles");
        let essentialEarnings = await fetchCategoryProduct("Essentials");
        let appliancesEarnings = await fetchCategoryProduct("Appliances");
        let booksEarnings = await fetchCategoryProduct("Books");
        let fashionEarnings = await fetchCategoryProduct("Fashion");

        let earnings = {
            totalEarning,
            mobileEarnings,
            essentialEarnings,
            appliancesEarnings,
            booksEarnings,
            fashionEarnings,
        };

        res.json(earnings);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

async function fetchCategoryProduct(category) {
    let earnings = 0;
    let categoryOrders = await Order.find({
        'products.product.category': category
    });

    //Reference how mongodb works in this querry
    //'products.product.category' when mention mongo read as 
    // products.some(item =>
    //     item.product.category === "Mobiles"
    // )
    //MongoDB matches documents if ANY array element satisfies the condition

    for (let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0; j < categoryOrders[i].products.length; j++) {
            const item = categoryOrders[i].products[j];
            if (item.product.category === category) {
                earnings += item.quantity * item.product.price;
            }
        }
    }
    return earnings;
}

module.exports = adminRouter;

