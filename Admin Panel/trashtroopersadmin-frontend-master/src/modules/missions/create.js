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
  faFileSignature,
  faInfoCircle
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
  CardText,
  Modal,
  ModalBody,
  ModalHeader,
  Button,
  Fade,
} from "shards-react";
import { API } from "../../constants";

class MissionCreate extends React.Component {
  state = {
    data: this.props.data || {
      requiredTroops: 0,
      dangerLevel: 0,
      details: "",
      missionName: "",
      address: "",
    },
    loading: false,
  };
  componentDidMount() {
    console.log("Mission: ", this.props.data);
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
          // height: "75%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          overflowX: "hidden",
          overflowY: "auto",
          paddingBottom: 10
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
              {this.props.data ? "Update" : "Create"} Mission
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
              <FontAwesomeIcon className="icon" color="#27ae61" icon={faFileSignature} />
              <FormInput
                onChange={(missionName) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      missionName: missionName.target.value,
                    },
                  });
                }}
                value={this.state.data.missionName}
                placeholder="Mission Name"
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
                onChange={(address) => {
                  this.setState({
                    data: { ...this.state.data, address: address.target.value },
                  });
                }}
                value={this.state.data.address}
                placeholder="Mission Address"
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

            {this.props.data &&<div
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
                disabled
                value={this.props.data.leader?.name || "-"}
                placeholder="Leader Name"
                style={{
                  fontSize: 12,
                  outline: "none",
                  backgroundColor: "transparent",
                  height: 40,
                  border: "none",
                  padding: "0px 10px 0px 10px",
                }}
              ></FormInput>
            </div>}

            <div
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
              <FontAwesomeIcon className="icon" color="#27ae61" icon={faInfoCircle} />
              <FormTextarea
                onChange={(details) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      details: details.target.value,
                    },
                  });
                }}
                value={this.state.data.details}
                rows={3}
                placeholder="Mission Details"
                style={{
                  fontSize: 12,
                  outline: "none",
                  backgroundColor: "transparent",
                  border: "none",
                  padding: "15px 10px 0px 10px",
                }}
              ></FormTextarea>
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
              <FontAwesomeIcon className="icon" color="#27ae61" icon={faMap} />
              <FormInput
                onChange={(siteImage) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      siteImage: siteImage.target.value,
                    },
                  });
                }}
                value={this.state.data.siteImage}
                placeholder="Site Image Link"
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
            <p
              style={{
                alignSelf: "center",
                color: "grey",
                fontWeight: "bold",
                fontSize: 12,
                margin: "5px 0px 5px 0px",
                padding: 0,
              }}
            >
              Required Troopers
            </p>
            <div
              style={{
                display: "flex",
                width: "100%",
                justifyContent: "center",
                alignItems: "center",
                flexWrap: "nowrap",
              }}
            >
              <FontAwesomeIcon
                onClick={() => {
                  if (this.state.data.requiredTroops > 0)
                    this.setState({
                      data: {
                        ...this.state.data,
                        requiredTroops: this.state.data.requiredTroops
                          ? this.state.data.requiredTroops - 1
                          : 0,
                      },
                    });
                }}
                className="icon"
                color="#27ae61"
                icon={faMinusCircle}
                style={{
                  width: 22,
                  height: 22,
                  margin: "0px 10px 0px 10px",

                  cursor: "pointer",
                }}
              />
              <p
                style={{
                  alignSelf: "center",
                  color: "#27ae61",
                  fontWeight: "bold",
                  fontSize: 12,
                  margin: "5px 0px 5px 0px",
                  padding: 0,
                }}
              >
                {this.state.data.requiredTroops || 0}
              </p>
              <FontAwesomeIcon
                onClick={() => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      requiredTroops: this.state.data.requiredTroops
                        ? this.state.data.requiredTroops + 1
                        : 1,
                    },
                  });
                }}
                className="icon"
                color="#27ae61"
                icon={faPlusCircle}
                style={{
                  width: 22,
                  height: 22,
                  margin: "0px 10px 0px 10px",

                  cursor: "pointer",
                }}
              />
            </div>
            <p
              style={{
                alignSelf: "center",
                color: "grey",
                fontWeight: "bold",
                fontSize: 12,
                margin: "5px 0px 5px 0px",
                padding: 0,
              }}
            >
              Danger Level
            </p>
            <div
              style={{
                width: "100%",
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                flexWrap: "nowrap",
                margin: "10px 0px 0px 0px",
              }}
            >
              <FontAwesomeIcon
                onClick={() => {
                  this.setState({
                    data: { ...this.state.data, dangerLevel: 1 },
                  });
                }}
                color={this.state.data.dangerLevel >= 1 ? "#ffb400" : "grey"}
                style={{
                  margin: "0px 10px 0px 10px",
                  cursor: "pointer",
                }}
                icon={faTrash}
              />
              <FontAwesomeIcon
                onClick={() => {
                  this.setState({
                    data: { ...this.state.data, dangerLevel: 2 },
                  });
                }}
                color={this.state.data.dangerLevel >= 2 ? "#ffb400" : "grey"}
                style={{
                  margin: "0px 10px 0px 10px",
                  cursor: "pointer",
                }}
                icon={faTrash}
              />
              <FontAwesomeIcon
                onClick={() => {
                  this.setState({
                    data: { ...this.state.data, dangerLevel: 3 },
                  });
                }}
                color={this.state.data.dangerLevel >= 3 ? "#ffb400" : "grey"}
                style={{
                  margin: "0px 10px 0px 10px",
                  cursor: "pointer",
                }}
                icon={faTrash}
              />
              <FontAwesomeIcon
                onClick={() => {
                  this.setState({
                    data: { ...this.state.data, dangerLevel: 4 },
                  });
                }}
                color={this.state.data.dangerLevel >= 4 ? "#ffb400" : "grey"}
                style={{
                  margin: "0px 10px 0px 10px",
                  cursor: "pointer",
                }}
                icon={faTrash}
              />
              <FontAwesomeIcon
                onClick={() => {
                  this.setState({
                    data: { ...this.state.data, dangerLevel: 5 },
                  });
                }}
                color={this.state.data.dangerLevel >= 5 ? "#ffb400" : "grey"}
                style={{
                  margin: "0px 10px 0px 10px",
                  cursor: "pointer",
                }}
                icon={faTrash}
              />
            </div>

            <div
              style={{
                display: "flex",
                justifyContent: "flex-end",
                alignItems: "center",
                flexWrap: "nowrap",
                alignSelf: "flex-end",
                marginRight: "10%",
                marginTop: 25,
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
      </Card>
      </div>
    );
  }

  create = async () => {
    this.setState({ loading: true });
    console.log("Update: ", this.state.data);
    try {
      let res = await fetch(
        this.props.data
          ? `${API}missions?id=${this.state.data.docID}`
          : `${API}missions`,
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

export default MissionCreate;
