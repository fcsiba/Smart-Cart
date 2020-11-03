import React from "react";
import {
  faEye,
  faEnvelope,
  faLock,
  faInfoCircle,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Lottie from "lottie-react-web";
import * as loading from "../loading.json";
import { API } from "../constants";
import {
  FormInput,
  Alert,
  FormTextarea,
  Badge,
  Collapse,
  Card,
  CardTitle,
  CardText,
  Modal,
  ModalBody,
  ModalHeader,
  Button,
  Fade,
} from "shards-react";

class Login extends React.Component {
  state = {
    user: null,
    loading: false,
    passwordVisible: false,
    email: "",
    password: "",
    alert: {},
  };
  render() {
    return (
      <div
        style={{
          width: "100%",
          height: window.innerHeight - 100,
          backgroundColor: "white",
          ...(this.state.loading && {
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }),
        }}
      >
        {this.state.alert.message && (
          <div style={{ position: "relative" }}>
            <Alert
              style={{
                display: "flex",
                flexWrap: "nowrap",
                alignItems: "center",
                justifyContent: "center",
                padding: 5,
                backgroundColor: "#ffb400",
              }}
              theme={this.state.alert.theme}
            >
              <FontAwesomeIcon
                color="white"
                style={{ margin: 5 }}
                icon={faInfoCircle}
              />
              <p style={{ flex: 0.9, margin: 0, color: "white" }}>
                {this.state.alert.message}
              </p>
              <Button
                onClick={() => {
                  this.setState({ alert: {} });
                }}
                style={{
                  background: "#27ae61",
                  outline: "none",
                  borderRadius: 25,
                  border: "1px solid #27ae61",
                  boxShadow: "0 0 3px black",
                  width: 50,
                  cursor: "pointer",
                }}
              >
                <p style={{ color: "white", padding: 5, margin: 0 }}>Ok</p>
              </Button>
            </Alert>
          </div>
        )}
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            width: "100%",
            height: window.innerHeight - 100,
          }}
        >
          <img style={{height: 150, width: 150, borderRadius: 75,marginBottom: 20 }} src="lg.jpeg"></img>
          <div
            style={{
              backgroundColor: "transparent",
              border: "2px solid #27ae61",
              borderRadius: 25,
              height: 40,
              width: 200,
              marginBottom: 25,
              display: "flex",
              alignItems: "center",
              padding: "0px 20px 0px 20px",
            }}
          >
            <FontAwesomeIcon className="icon" color="grey" icon={faEnvelope} />
            <FormInput
              onChange={(email) => {
                this.setState({ email: email.target.value });
              }}
              value={this.state.email}
              placeholder="Email"
              style={{
                fontSize: 12,
                outline: "none",
                backgroundColor: "transparent",
                height: 40,
                border: "none",
                padding: "0px 10px 0px 10px",
              }}
            ></FormInput>
          </div>

          <div
            style={{
              backgroundColor: "transparent",
              border: "2px solid #27ae61",
              borderRadius: 25,
              height: 40,
              width: 220,
              marginBottom: 25,
              display: "flex",
              alignItems: "center",
              padding: "0px 10px 0px 10px",
            }}
          >
            <FontAwesomeIcon className="icon" color="grey" icon={faLock} />
            <FormInput
              placeholder="Password"
              type={this.state.passwordVisible ? "text" : "password"}
              onChange={(password) => {
                this.setState({ password: password.target.value });
              }}
              value={this.state.password}
              style={{
                fontSize: 12,
                outline: "none",
                backgroundColor: "transparent",
                height: 40,
                border: "none",
                padding: "0px 10px 0px 10px",
              }}
            ></FormInput>
            <FontAwesomeIcon
              className="icon"
              color="grey"
              icon={faEye}
              style={{ cursor: "pointer" }}
              onClick={() => {
                this.setState({
                  passwordVisible: !this.state.passwordVisible,
                });
              }}
            />
          </div>
          <div
            onClick={() => {
              this.login();
            }}
            style={{
              backgroundColor: this.state.loading ? "white" : "#27ae61",
              border: "1px solid #27ae61",
              borderRadius: 25,
              height: 40,
              width: 220,
              marginBottom: 25,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              padding: "0px 10px 0px 10px",
              boxShadow: "0 0 3px black",
              cursor: "pointer",
            }}
          >
            {!this.state.loading && (
              <p style={{ color: "white", fontSize: 12 }}>LOG IN</p>
            )}
            {this.state.loading && (
              <Lottie
                options={{
                  animationData: loading.default,
                }}
                height={75}
                width={75}
              />
            )}
          </div>
        </div>
      </div>
    );
  }

  login = async () => {
    if (!(this.state.email || this.state.password)) {
      this.setState({
        alert: {
          message: "Please enter your credentials correctly.",
          theme: "warning",
        },
      });
      return;
    }
    this.setState({ loading: true, alert: {} });
    try {
      let res = await fetch(`${API}login`, {
        method: "post",
        headers: {
          Accept: "*/*",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: this.state.email,
          password: this.state.password,
        }),
      });
      let data = await res.json();
      console.log(data);
      if (res.status != 200) {
        throw data;
      }
      this.setState({ loading: false });
      if (this.props.callback) {
        this.props.callback(data);
      }
    } catch (error) {
      this.setState({ loading: false });
      if (error instanceof Error) {
        this.setState({
          alert: {
            message: "We encountered some connectivity issues.",
            theme: "warning",
          },
        });
        return;
      }
      this.setState({ alert: { message: error.message, theme: "danger" } });
      return;
    }
  };
}

export default Login;
