//Import from packages
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");

//Import from files
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const produtRouter = require("./routes/product");
const userRouter = require("./routes/user");

//Initialize
const app = express();
const PORT = process.env.PORT;
const DB = process.env.MONGO_URI;

//Midleware
app.use(express.json())
app.use(authRouter);
app.use(adminRouter);
app.use(produtRouter);
app.use(userRouter);

//Connection
mongoose.connect(DB).then(() => {
    console.log("Mongo DB Connected Successfully!");
}).catch((e) => {
    console.log(e);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected to the server Successfully!`);
})

