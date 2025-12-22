const express = require("express");
const User = require("../models/user");
const bcryptJs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth_middle");

const authRouter = express.Router();

//SignUp-Route
authRouter.post("/api/signup", async (req, res) => {
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: "User with same email Id already Exist!" });
        }

        const hashedPassword = await bcryptJs.hash(password, 8);

        let user = new User({
            name,
            email,
            password: hashedPassword,
        });

        user = await user.save();
        const { password: pw, ...userDate } = user._doc;
        res.json(userDate);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//SignIn-Route
authRouter.post("/api/signin", async (req, res) => {
    try {
        const { email, password } = req.body;

        let user = await User.findOne({ email });
        if (!user) return res.status(400).json({ msg: "Email does not exist!" });

        const isMatch = await bcryptJs.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ msg: "Incorrect password!" });

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

        // populate cart before sending to Flutter
        user = await User.findById(user._id)
            .select("-password")
            .populate("cart.product", "productName price images ratings");

        res.json({ token, ...user._doc });

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


//TokenIsValid
authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) return res.json(false);

        const isVerified = jwt.verify(token, process.env.JWT_SECRET);
        if (!isVerified) return res.json(false);

        const user = await User.findById(isVerified.id);
        if (!user) return res.json(false);
        res.json(true);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//GetUserData
authRouter.get("/getUser", auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({ ...user._doc, token: req.token });
});


module.exports = authRouter;