const express = require("express");
const auth = require("../middlewares/auth_middle");
const { Product } = require("../models/product");
const User = require("../models/user");
const { default: mongoose } = require("mongoose");
const Order = require("../models/order");
const userRouter = express.Router();

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);

        let user = await User.findById(req.user);

        let cartItem = user.cart.find((item) => item.product._id.equals(product._id));
        if (cartItem) {
            //Increase Qty
            cartItem.quantity += 1;
        } else {
            //Add new product
            user.cart.push({ product, quantity: 1 });
        }
        await user.save();
        res.json(user.cart);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
    try {
        const { id } = req.params;

        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ msg: "Invalid Product ID" });
        }

        let user = await User.findById(req.user);
        if (!user) return res.status(400).json({ msg: "User not found" });

        const cartItemIndex = user.cart.findIndex(
            (item) => item.product._id.toString() === id
        );

        if (cartItemIndex === -1) {
            return res.status(400).json({ msg: "Product not in cart" });
        }

        if (user.cart[cartItemIndex].quantity === 1) {
            user.cart.splice(cartItemIndex, 1);
        } else {
            user.cart[cartItemIndex].quantity -= 1;
        }

        await user.save();
        res.json(user.cart);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Save User address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
    try {
        const { address } = req.body;
        let user = await User.findById(req.user);
        if (!user) return res.status(400).json({ msg: "User not found" });

        user.address = address;
        user = await user.save();
        res.json(user);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Order Product
userRouter.post("/api/order", auth, async (req, res) => {
    try {
        const { cart, totalPrice, address } = req.body;
        let products = [];

        // for (let i = 0; i < cart.length; i++) {
        //     let product = await Product.findById(cart[i].product._id);
        //     if (product.qty >= cart[i].quantity) {
        //         product.qty -= cart[i].quantity;
        //         products.push({ product, quantity: cart[i].quantity });
        //         await product.save();
        //     } else {
        //         return res.status(400).json({ msg: `${product.productName} is out of stock` });
        //     }
        // }

        for (let item of cart) {
            const product = await Product.findById(item.product._id);

            if (product.qty < item.quantity) {
                return res.status(400).json({
                    msg: `${product.productName} is out of stock`,
                });
            }

            product.qty -= item.quantity;
            await product.save();

            products.push({
                product,
                quantity: item.quantity,
            });
        }

        let user = await User.findById(req.user);
        user.cart = [];
        user = await user.save();

        let order = new Order({
            products,
            totalPrice,
            address,
            userId: req.user,
            orderedAt: new Date().getTime(),
        });

        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Fetch Orders
userRouter.get("/api/user-orders", auth, async (req, res) => {
    try {
        const orders = await Order.find({ userId: req.user });
        res.json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = userRouter;
