import React from "react";
import {
  faEye,
  faMap,
  faMapMarker,
  faTrash,
  faPlusCircle,
  faMinusCircle,
  faTimesCircle,
  faUser,
  faEnvelope,
  faLock,
  faImages,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import * as loading from "../../loading.json";
import Lottie from "lottie-react-web";
import {
  FormInput,
  Alert,
  FormTextarea,
  Badge,
  Collapse,
  Card,
  CardTitle,
  FormCheckbox,
  CardText,
  Modal,
  ModalBody,
  ModalHeader,
  Button,
  Fade,
} from "shards-react";
import { API } from "../../constants";

class UserCreate extends React.Component {
  state = {
    data: this.props.data || {
      name: "",
      email: "",
      profilePhoto: "",
      isAdmin: false,
      password: "",
    },
    loading: false,
  };
  componentDidMount() {
    console.log("User: ", this.props.data);
  }
  render() {
    return (
      <div style={{ position: "absolute", width: "100%", height: "100%", backgroundColor: "rgba(0,0,0,0.4)"}}>
      <Card
        style={{
          position: "absolute",
          zIndex: 10,
          top: "10%",
          left: "30%",
          borderRadius: 20,
          backgroundColor: "white",
          boxShadow: "0 0 3px black",
          width: "40%",
          // height: "80%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          overflowX: "hidden",
          overflowY: "auto",
        }}
      >
        {this.state.loading && (
          <Lottie
            options={{
              animationData: loading.default,
            }}
            height={200}
            width={200}
          />
        )}
        {!this.state.loading && (
          <>
            <CardTitle style={{ color: "#27ae61" }}>
              {this.props.data ? "Update" : "Create"} User
            </CardTitle>
            <FontAwesomeIcon
              color="black"
              style={{
                position: "absolute",
                right: 10,
                top: 10,
                cursor: "pointer",
              }}
              icon={faTimesCircle}
              onClick={() => {
                this.props.close();
              }}
            />

            <div
              style={{
                backgroundColor: "transparent",
                border: "2px solid #27ae61",
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon className="icon" color="#27ae61" icon={faUser} />
              <FormInput
                onChange={(name) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      name: name.target.value,
                    },
                  });
                }}
                value={this.state.data.name}
                placeholder="Name"
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

            {/* <div
              style={{
                backgroundColor: "transparent",
                border: "2px solid #27ae61",
                borderRadius: 10,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon className="icon" color="#27ae61" icon={faMap} />
              <FormTextarea
                onChange={(detail) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      detail: detail.target.value,
                    },
                  });
                }}
                value={this.state.data.detail}
                rows={3}
                placeholder="Offer Details"
                style={{
                  fontSize: 12,
                  outline: "none",
                  backgroundColor: "transparent",
                  border: "none",
                  padding: "15px 10px 0px 10px",
                }}
              ></FormTextarea>
            </div> */}

            <div
              style={{
                backgroundColor: "transparent",
                border: "2px solid #27ae61",
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon
                className="icon"
                color="#27ae61"
                icon={faEnvelope}
              />
              <FormInput
                onChange={(email) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      email: email.target.value,
                    },
                  });
                }}
                value={this.state.data.email}
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

            {/* <div
              style={{
                backgroundColor: "transparent",
                border: "2px solid #27ae61",
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon
                className="icon"
                color="#27ae61"
                icon={faMapMarker}
              />
              <FormInput
                onChange={(points) => {
                  this.setState({
                    data: { ...this.state.data, points: points.target.value },
                  });
                }}
                type="numeric"
                value={this.state.data.points}
                placeholder="Points"
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
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon
                className="icon"
                color="#27ae61"
                icon={faMapMarker}
              />
              <FormInput
                onChange={(type) => {
                  this.setState({
                    data: { ...this.state.data, type: type.target.value },
                  });
                }}
                value={this.state.data.type}
                placeholder="Offer Type"
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
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon
                className="icon"
                color="#27ae61"
                icon={faMapMarker}
              />
              <FormInput
                onChange={(vendor) => {
                  this.setState({
                    data: { ...this.state.data, vendor: vendor.target.value },
                  });
                }}
                value={this.state.data.vendor}
                placeholder="Vendor"
                style={{
                  fontSize: 12,
                  outline: "none",
                  backgroundColor: "transparent",
                  height: 40,
                  border: "none",
                  padding: "0px 10px 0px 10px",
                }}
              ></FormInput>
            </div> */}

            <div
              style={{
                backgroundColor: "transparent",
                border: "2px solid #27ae61",
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon
                className="icon"
                color="#27ae61"
                icon={faLock}
              />
              <FormInput
                onChange={(password) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      password: password.target.value,
                    },
                  });
                }}
                value={this.state.data.password}
                placeholder="Password"
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
                borderRadius: 10,
                height: 40,
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon
                className="icon"
                color="#27ae61"
                icon={faImages}
              />
              <FormInput
                onChange={(profilePhoto) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      profilePhoto: profilePhoto.target.value,
                    },
                  });
                }}
                value={this.state.data.profilePhoto}
                placeholder="Profile Photo Link"
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
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                alignSelf: "center",
                flexWrap: "nowrap",
              }}
            >
              <p
                style={{
                  fontSize: 14,
                  color: "#27ae61",
                  padding: 0,
                  margin: 0,
                  cursor: "pointer",
                  alignSelf: "center",
                }}
              >
                Admin{" "}
              </p>
              <FormCheckbox
                onChange={(checked) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      isAdmin: !this.state.data.isAdmin,
                    },
                  });
                }}
                checked={this.state.data.isAdmin}
                inline={true}
                style={{}}
              ></FormCheckbox>
            </div>
            <div
              style={{
                display: "flex",
                justifyContent: "flex-end",
                alignItems: "center",
                flexWrap: "nowrap",
                alignSelf: "flex-end",
                marginRight: "10%",
                // marginTop: 25,
              }}
            >
              <Button
                style={{
                  backgroundColor: "transparent",
                  outline: "none",
                  border: "none",
                  margin: 5,
                }}
                onClick={() => {
                  this.props.close();
                }}
              >
                <p
                  style={{
                    fontSize: 14,
                    color: "#27ae61",
                    padding: 0,
                    margin: 0,
                    cursor: "pointer",
                  }}
                >
                  Cancel
                </p>
              </Button>
              <Button
                style={{
                  backgroundColor: "#27ae61",

                  border: 0,
                  boxShadow: "0 0 3px black",
                  margin: 5,
                  borderRadius: 1,
                  padding: "8px 12px 8px 12px",

                  cursor: "pointer",
                  outline: "none",
                }}
                onClick={() => {
                  this.create();
                }}
              >
                <p
                  style={{
                    fontSize: 14,
                    color: "white",
                    padding: 0,
                    margin: 0,
                  }}
                >
                  {this.props.data ? "UPDATE" : "CREATE"}
                </p>
              </Button>
            </div>
          </>
        )}
      </Card></div>
    );
  }

  create = async () => {
    this.setState({ loading: true });
    console.log("Update: ", this.state.data);
    try {
      let res = await fetch(
        this.props.data
          ? `${API}users?id=${this.state.data.uid}`
          : `${API}users`,
        {
          method: this.props.data ? "put" : "post",
          headers: {
            Accept: "*/*",
            Authorization: "Bearer " + this.props.user.token,
            "Content-Type": "application/json",
          },
          body: JSON.stringify(this.state.data),
        }
      );
      let data = await res.json();
      console.log(data);
      if (res.status != 200) {
        throw data;
      }
      this.setState({ loading: false });
      if (this.props.callback) {
        this.props.callback({ message: data.message, theme: "success" });
      }
      this.props.close();
    } catch (error) {
      this.setState({ loading: false });
      if (error instanceof Error) {
        this.props.callback({
          message: "We encountered some connectivity issues.",
          theme: "warning",
        });
        // this.setState({
        //   alert: {
        //     message: "We encountered some connectivity issues.",
        //     theme: "warning",
        //   },
        // });
        return;
      }
      this.props.callback({ message: error.error, theme: "danger" });
      //   this.setState({ alert: { message: error.message, theme: "danger" } });
      return;
    }
  };
}

export default UserCreate;
