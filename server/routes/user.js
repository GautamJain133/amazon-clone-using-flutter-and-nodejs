const express = require("express");
const userRouter = express.Router();
const auth = require("../middleware/auth");
const { Product, productSchema } = require("../models/product.js");
const User = require("../models/user.js");
const Order = require("../models/orders.js");

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const id = req.body.id;

    let product = await Product.findById(id);
    console.log("request for add to cart" + req.body.id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(id)) {
          console.log("hi");
          isProductFound = true;
        }
      }

      if (isProductFound == true) {
        let prod = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        prod.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const id = req.params.id;

    let product = await Product.findById(id);
    const user_id = req.user;
    let user = await User.findById(user_id);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(id)) {
        if (user.cart[i].quantity == 1) {
          // to product hi remove karna hai cart se

          user.cart.splice(i, 1);
        } else {
          // to khali quantity decrese karni hai

          user.cart[i].quantity -= 1;
        }

        break;
      }
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    //console.log('save address api calles with body '+req.body.address);
    const user_id = req.user;
    let user = await User.findById(user_id);

    const address = req.body.address;

    // console.log('user addess is '+ user.username);
    user.useraddress = address;

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// order product

userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;

    let products = [];

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);

      console.log(product.product_quantity);
      console.log(cart[i].quantity);

      if (product.product_quantity >= cart[i].quantity) {
        console.log("yha tk " + cart[i].quantity);

        product.product_quantity -= cart[i].quantity;

        products.push({ product, quantity: cart[i].quantity });

        await product.save();
      } else {
        console.log("hi i am here");

        return res
          .status(400)
          .json({ msg: `${product.product_name} is out of stock!` });
      }
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

// getting the orders

userRouter.get("/api/your-orders", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });

    console.log(`your orders is ${orders}`);

    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;
