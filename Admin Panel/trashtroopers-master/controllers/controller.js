const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];
module.exports = function (db) {
  //CRUD Controller Component

  const express = require("express");
  const router = express.Router({ mergeParams: true });

  //CRUD Routes Missions
  router.get("/missions", getMission);
  router.put("/missions", updateMission);
  router.post("/missions", createMission);
  router.delete("/missions", deleteMission);

  //CRUD Routes Offers
  router.get("/offers", getOffer);
  router.put("/offers", updateOffer);
  router.post("/offers", createOffer);
  router.delete("/offers", deleteOffer);

  //CRUD Routes Users
  router.get("/users", getUser);
  router.put("/users", updateUser);
  router.post("/users", createUser);
  router.delete("/users", deleteUser);

  //Mission Controllers
  async function createMission(req, res, next) {
    let data = { ...req.body };
    try {
      const ref = db.collection("missions").doc();
      console.log("Id: ", ref.id);
      let date = new Date();
      const response = await db
        .collection("missions")
        .doc(ref.id)
        .set({ ...data, docID: ref.id, createdAt: getDateTime(date), updatedAt:  getDateTime(date)});
      res.status(200).json({
        status: true,
        message: "Mission created successfully with id " + ref.id,
      });
    } catch (error) {
      console.log("Error In createMission: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while creating the mission.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while creating the mission.",
        });
      return;
    }
  }

  async function updateMission(req, res, next) {
    let data = { ...req.body };
    try {
      const query = await db
        .collection("missions")
        .where("docID", "==", req.query.id)
        .get();
      if (query.empty) {
        res.status(400).json({
          status: true,
          error: "Couldn't find the mission.",
        });
        return;
      }
      let mission;
      query.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        mission = doc.data();
      });
      await db
        .collection("missions")
        .doc(req.query.id)
        .update({ ...mission, ...data, updatedAt:  getDateTime(new Date()) });
      console.log("Updated Mission: ", { ...mission, ...data });
      res.status(200).json({
        status: true,
        message: "Mission updated successfully.",
      });
    } catch (error) {
      console.log("Error In updateMission: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while updating the mission.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while updating the mission.",
        });
      return;
    }
  }

  async function deleteMission(req, res, next) {
    let data = { id: req.query.id };
    try {
      const query = await db
        .collection("missions")
        .where("docID", "==", data.id)
        .get();
      if (query.empty) {
        res.status(400).json({
          status: true,
          error: "Couldn't find the mission.",
        });
        return;
      }
      query.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        doc.ref.delete();
      });
      res
        .status(200)
        .json({ status: true, message: "Mission deleted successfully." });
    } catch (error) {
      console.log("Error In deleteMission: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while deleting the mission.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while deleting the mission.",
        });
      return;
    }
  }

  async function getMission(req, res, next) {
    let data = { id: req.query.id, offset: req.query.offset };

    try {
      let snapshot;
      if (data.id) {
        snapshot = await db
          .collection("missions")
          .where("docID", "==", data.id)
          .get();
        if (snapshot.empty) {
          res.status(400).json({
            status: true,
            error: "We couldn't find this mission.",
          });
          return;
        }
        let mission;
        snapshot.forEach((doc) => {
          console.log(doc.id, "=>", doc.data());
          mission = doc.data();
        });
        res.status(200).json({
          status: true,
          message: "Mission found successfully.",
          mission,
        });
        return;
      }
      console.log("Offset: ", data.offset);
      snapshot = await db
        .collection("missions")
        .limit(5)
        .offset(data.offset * 5)
        .get();
      if (snapshot.empty) {
        res.status(400).json({
          status: true,
          error: "No more missions found.",
        });
        return;
      }
      let missions = [];
      snapshot.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        missions.push(doc.data());
      });
      res.status(200).json({
        status: true,
        message: "Mission found successfully.",
        missions,
      });
      return;
    } catch (error) {
      console.log("Error In getMission: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while fetching the mission(s).",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while fetching the mission(s).",
        });
      return;
    }
  }

  //Offer Controllers
  async function createOffer(req, res, next) {
    let data = { ...req.body };
    let date = new Date();
    try {
      const ref = db.collection("offers").doc();
      console.log("Id: ", ref.id);
      const response = await db
        .collection("offers")
        .doc(ref.id)
        .set({ ...data, docID: ref.id, createdAt: getDateTime(date), updatedAt:  getDateTime(date) });
      res.status(200).json({
        status: true,
        message: "Offer created successfully with id " + ref.id,
      });
    } catch (error) {
      console.log("Error In createOffer: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while creating the offer.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while creating the offer.",
        });
      return;
    }
  }

  async function updateOffer(req, res, next) {
    let data = { ...req.body };
    try {
      const query = await db
        .collection("offers")
        .where("docID", "==", req.query.id)
        .get();
      if (query.empty) {
        res.status(400).json({
          status: true,
          error: "Couldn't find the offer.",
        });
        return;
      }
      let offer;
      query.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        offer = doc.data();
      });
      await db
        .collection("offers")
        .doc(req.query.id)
        .update({ ...offer, ...data,  updatedAt:  getDateTime(new Date()) });
      console.log("Updated Offer: ", { ...offer, ...data });
      res.status(200).json({
        status: true,
        message: "Offer updated successfully.",
      });
    } catch (error) {
      console.log("Error In updateOffer: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while updating the offer.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while updating the offer.",
        });
      return;
    }
  }

  async function deleteOffer(req, res, next) {
    let data = { id: req.query.id };
    try {
      const query = await db
        .collection("offers")
        .where("docID", "==", data.id)
        .get();
      if (query.empty) {
        res.status(400).json({
          status: true,
          error: "Couldn't find the offer.",
        });
        return;
      }
      query.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        doc.ref.delete();
      });
      res
        .status(200)
        .json({ status: true, message: "Offer deleted successfully." });
    } catch (error) {
      console.log("Error In deleteOffer: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while deleting the Offer.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while deleting the Offer.",
        });
      return;
    }
  }

  async function getOffer(req, res, next) {
    let data = { id: req.query.id, offset: req.query.offset };

    try {
      let snapshot;
      if (data.id) {
        snapshot = await db
          .collection("offers")
          .where("docID", "==", data.id)
          .get();
        if (snapshot.empty) {
          res.status(400).json({
            status: true,
            error: "We couldn't find this offer.",
          });
          return;
        }
        let offer;
        snapshot.forEach((doc) => {
          console.log(doc.id, "=>", doc.data());
          offer = doc.data();
        });
        res.status(200).json({
          status: true,
          message: "Offer found successfully.",
          offer,
        });
      }

      console.log("Offset: ", data.offset);
      snapshot = await db
        .collection("offers")
        .limit(5)
        .offset(data.offset * 5)
        .get();
      if (snapshot.empty) {
        res.status(400).json({
          status: true,
          error: "No more offers found.",
        });
        return;
      }
      let offers = [];
      snapshot.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        offers.push(doc.data());
      });
      res.status(200).json({
        status: true,
        message: "Offers found successfully.",
        offers,
      });
      return;
    } catch (error) {
      console.log("Error In getOffer: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while fetching the offer.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while fetching the offer.",
        });
      return;
    }
  }

  //User Controllers
  async function createUser(req, res, next) {
    let data = { ...req.body };
    let date = new Date();
    try {
      const ref = db.collection("users").doc();
      console.log("Id: ", ref.id);
      const response = await db
        .collection("users")
        .doc(ref.id)
        .set({ ...data, uid: ref.id, ...(data.isAdmin && { userType: "3" }), createdAt: getDateTime(date), updatedAt:  getDateTime(date) });
      res.status(200).json({
        status: true,
        message: "User created successfully with id " + ref.id,
      });
    } catch (error) {
      console.log("Error In createUser: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while creating the user.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while creating the user.",
        });
      return;
    }
  }

  async function updateUser(req, res, next) {
    let data = { ...req.body };
    try {
      const query = await db
        .collection("users")
        .where("uid", "==", req.query.id)
        .get();
      if (query.empty) {
        res.status(400).json({
          status: true,
          error: "Couldn't find the user.",
        });
        return;
      }
      let user;
      query.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        user = doc.data();
      });
      await db
        .collection("users")
        .doc(req.query.id)
        .update({
          ...user,
          ...data,
          ...(data.isAdmin && { userType: "3" }),
          ...(!data.isAdmin && { userType: "2" }),
          updatedAt:  getDateTime(new Date())
        });
      console.log("Updated User: ", { ...user, ...data });
      res.status(200).json({
        status: true,
        message: "User updated successfully.",
      });
    } catch (error) {
      console.log("Error In updateUser: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while updating the user.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while updating the user.",
        });
      return;
    }
  }

  async function deleteUser(req, res, next) {
    let data = { id: req.query.id };
    try {
      const query = await db
        .collection("users")
        .where("uid", "==", data.id)
        .get();
      if (query.empty) {
        res.status(400).json({
          status: true,
          error: "Couldn't find the user.",
        });
        return;
      }
      query.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        doc.ref.delete();
      });
      res
        .status(200)
        .json({ status: true, message: "User deleted successfully." });
    } catch (error) {
      console.log("Error In deleteUser: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while deleting the User.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while deleting the User.",
        });
      return;
    }
  }

  async function getUser(req, res, next) {
    let data = { id: req.query.id, offset: req.query.offset };

    try {
      let snapshot;
      if (data.id) {
        snapshot = await db
          .collection("users")
          .where("uid", "==", data.id)
          .get();
        if (snapshot.empty) {
          res.status(400).json({
            status: true,
            error: "We couldn't find this user.",
          });
          return;
        }
        let user;
        snapshot.forEach((doc) => {
          console.log(doc.id, "=>", doc.data());
          user = doc.data();
        });
        res.status(200).json({
          status: true,
          message: "User found successfully.",
          user,
        });
      }
      console.log("Offset: ", data.offset);
      snapshot = await db
        .collection("users")
        .limit(5)
        .offset(data.offset * 5)
        .get();
      if (snapshot.empty) {
        res.status(400).json({
          status: true,
          error: "No more users found.",
        });
        return;
      }
      let users = [];
      snapshot.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        users.push(doc.data());
      });
      res.status(200).json({
        status: true,
        message: "Users found successfully.",
        users,
      });
      return;
    } catch (error) {
      console.log("Error In getUser: ", error);
      if (error instanceof Error)
        res.status(500).json({
          status: true,
          error: "There was an error while fetching the user.",
        });
      else
        res.status(400).json({
          status: true,
          error: "There was an error while fetching the user.",
        });
      return;
    }
  }

  return router;
};

function getDateTime(date) {
  let month = months[date.getMonth()];
  let timezoneFactor = 5; //Pk Offset on Heroku Server
  let day = date.getDate();
  let year = date.getFullYear();
  let hours = date.getHours() + timezoneFactor;
  let minutes = date.getMinutes() < 10 ? "0"+date.getMinutes() : date.getMinutes();
  let seconds = date.getSeconds() < 10 ? "0"+date.getSeconds() : date.getSeconds();
  let ampm = hours >= 12 ? "PM" : "AM";

  let dateString = month + " " + day + ", " + year + " at " + hours%12 + ":" + minutes + ":" + seconds + " " +ampm + " UTC+" + timezoneFactor;
  return dateString;
}
