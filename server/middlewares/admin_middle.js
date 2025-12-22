const jwt = require("jsonwebtoken");
const User = require("../models/user");

const admin = async (req, res, next) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) return res.status(401).json({ msg: "No Auth Token, Access Denied!" });

        const isVerified = jwt.verify(token, process.env.JWT_SECRET);
        if (!isVerified) return res.status(401).json({ msg: "Token Verified Failed, Access Denied!" });

        const user = await User.findById(isVerified.id);
        if (user.type != "admin") {
            return res.status(401).json({ msg: "Sorry!, Your not an Admin" })
        }
        req.user = user;
        req.token = token;

        next();
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}

module.exports = admin;