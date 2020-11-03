/* This Server is for handling Changes in MongoDB depending on Changes done to the Blockchain
  It is a sub-module of TETS (system) designed to counter the Slow Transaction Speeds on Blockchain
  All Rights Reserved By TETS*/

require("dotenv").config();
const express = require("express");
const app = express();
const http = require("http").createServer(app);
const cors = require("cors");
const bodyParser = require("body-parser");
const errorHandler = require("./controllers/errorHandler");
const controller = require("./controllers/controller");
const jwt = require("jsonwebtoken");
const fs = require("fs");
const admin = require("firebase-admin");

const serviceAccount = require("./trash-troopers-4bcb08067fcf.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(cors());

app.post("/api/v1/login", async (req, res) => {
  console.log(req.body);
  if (!Object.keys(req.body).length) {
    res
      .status(400)
      .json({ message: "Please verify that your credentials are valid." });

    return;
  }
  let data = {
    ...req.body,
  };

  const usersRef = db.collection("users");
  const snapshot = await usersRef
    .where("email", "==", data.email)
    .where("password", "==", data.password)
    .where("userType", "==", "3")
    .get();
  if (snapshot.empty) {
    console.log("No matching documents.");
    res
      .status(400)
      .json({ message: "Please verify that your credentials are valid." });
    return;
  }

  snapshot.forEach((doc) => {
    console.log(doc.id, "=>", doc.data());
    data = doc.data();
  });

  jwt.sign(
    data,
    process.env.JWT_SECRET,
    { algorithm: "HS256", expiresIn: "24h" },
    (err, token) => {
      console.log("Token: ", token);
      res.json({
        token: token,
        iat: Date.now(),
        message: "Successfully Logged In",
        data,
      });
    }
  );
});

//Sub Routes
app.use("/api/v1", verifyToken, controller(db));

// app.use(errorHandler);

const port = process.env.PORT || 8080;

//The Server Instance
const server = http.listen(port, function () {
  console.log("Server listening on port " + port);
});

//Verify Token
function verifyToken(req, res, next) {
  //Get Token From Header
  const bearer = req.headers["authorization"];
  if (typeof bearer !== "undefined") {
    const token = bearer.split(" ")[1];
    jwt.verify(
      token,
      process.env.JWT_SECRET,
      { algorithms: ["HS256"] },
      (err, authData) => {
        if (err) {
          console.log(err);
          res.json({ message: "This action is Forbidden." });
        } else {
          // res.json({ message: "Verification Successful", authData });
          next();
        }
      }
    );
  } else {
    res.json({ message: "This action is Forbidden." });
  }
}
