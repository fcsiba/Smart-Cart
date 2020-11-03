import React from "react";
import { faEye, faEnvelope, faLock } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Lottie from "lottie-react-web";
import * as loading from "./loading.json";
import "./App.css";
import Login from "./modules/login";
import MissionList from "./modules/missions/list";
import OfferList from "./modules/offers/list";
import UserList from "./modules/users/list";

class App extends React.Component {
  state = {
    user: null,
    loading: true,
    activeComponent: "missions",
  };
  componentDidMount() {
    document.title = "Admin Panel - Trash Troopers";
    let user = localStorage.getItem("user");
    if (user) {
      user = JSON.parse(user);
      console.log("User: ", user);
      if (Date.now() <= user.iat + 43200000) {
        this.setState({ user, loading: false });
      } else this.setState({ loading: false });
    }
  }
  render() {
    return (
      <div
        style={{
          width: "100%",
          height: "100%",
          backgroundColor: "white",
        }}
      >
        <div
          style={{
            width: "100%",
            height: 100,
            backgroundColor: "#27ae61",
            display: "flex",
            // justifyContent: "flex-start",
            alignItems: "center",
          }}
        >
          <img style={{height: 95, width: 102, borderRadius: 45, marginLeft: 50, }} src="lw.jpeg"></img>
          <h2 style={{ color: "white", marginLeft: 50 }}>
            Trash Troopers
            <sub style={{ color: "white", fontSize: 10 }}>Admin Panel</sub>
          </h2>
          {this.state.user ? (
            <div
              style={{
                position: "absolute",
                right: 10,
                top: 10,
                display: "flex",
                flexDirection: "column",
                justifyContent: "center",
                alignItems: "center",
              }}
            >
              <img
                src={this.state.user.data.profilePhoto}
                style={{
                  height: 50,
                  width: 50,
                  borderRadius: 25,
                  border: "1px solid white",
                  overflow: "hidden",
                }}
              ></img>
              <h3
                style={{
                  color: "white",
                  fontSize: 14,
                }}
              >
                {this.state.user.data.name}
              </h3>
            </div>
          ) : null}
        </div>
        {!this.state.user && (
          <Login
            callback={(user) => {
              console.log("User: ", user);
              this.setState({ user });
              localStorage.setItem("user", JSON.stringify(user));
            }}
          ></Login>
        )}
        {this.state.user && (
          <div style={{ display: "flex", flexWrap: "nowrap" }}>
            <div
              style={{
                width: "20%",
                height: window.innerHeight - 100,
                backgroundColor: "#27ae61",
                display: "flex",
                justifyContent: "flex-start",
                alignItems: "center",
                flexDirection: "column",
              }}
            >
              <h4
                onClick={() => {
                  this.setState({ activeComponent: "missions" });
                }}
                className="slink"
                style={{
                  fontWeight: 100,
                  marginTop: 100,
                  color:
                    this.state.activeComponent == "missions"
                      ? "black"
                      : "white",
                  cursor: "pointer",

                  backgroundColor:
                    this.state.activeComponent == "missions"
                      ? "white"
                      : "transparent",
                  padding: "10px 15px 10px 15px",
                  borderRadius: 20,
                }}
              >
                Missions
              </h4>
              <h4
                onClick={() => {
                  this.setState({ activeComponent: "offers" });
                }}
                className="slink"
                style={{
                  fontWeight: 100,
                  marginTop: 100,
                  color:
                    this.state.activeComponent == "offers" ? "black" : "white",
                  cursor: "pointer",

                  backgroundColor:
                    this.state.activeComponent == "offers"
                      ? "white"
                      : "transparent",
                  padding: "10px 15px 10px 15px",
                  borderRadius: 20,
                }}
              >
                Offers
              </h4>
              <h4
                onClick={() => {
                  this.setState({ activeComponent: "users" });
                }}
                className="slink"
                style={{
                  fontWeight: 100,
                  marginTop: 100,
                  color:
                    this.state.activeComponent == "users" ? "black" : "white",
                  cursor: "pointer",

                  backgroundColor:
                    this.state.activeComponent == "users"
                      ? "white"
                      : "transparent",
                  padding: "10px 15px 10px 15px",
                  borderRadius: 20,
                }}
              >
                Users
              </h4>

              <h4
                onClick={() => {
                  localStorage.removeItem("user");
                  window.location.reload();
                }}
                className="slink"
                style={{
                  fontWeight: 100,
                  marginTop: 100,
                  color: "white",
                  cursor: "pointer",

                  backgroundColor: "transparent",
                  padding: "10px 15px 10px 15px",
                  borderRadius: 20,
                }}
              >
                Logout
              </h4>
            </div>
            <div style={{ width: "80%", overflowY: "auto" }}>
              {this.state.activeComponent === "missions" ? (
                <MissionList user={this.state.user}></MissionList>
              ) : this.state.activeComponent === "offers" ? (
                <OfferList user={this.state.user}></OfferList>
              ) : this.state.activeComponent === "users" ? (
                <UserList user={this.state.user}></UserList>
              ) : null}
            </div>
          </div>
        )}
      </div>
    );
  }
}

export default App;
