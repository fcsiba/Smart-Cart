import React from "react";
import {
  faEye,
  faMap,
  faMapMarker,
  faTrash,
  faPlusCircle,
  faMinusCircle,
  faTimesCircle,
  faFileSignature,
  faInfoCircle,
  faSortNumericDownAlt,
  faSortNumericUpAlt,
  faStar,
  faBuilding,
  faImages
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

class OfferCreate extends React.Component {
  state = {
    data: this.props.data || {
      name: "",
      detail: "",
      offerCode: "",
      points: 0,
      type: "",
      vendor: "",
      image: "",
    },
    loading: false,
  };
  componentDidMount() {
    console.log("Offer: ", this.props.data);
  }
  render() {
    return (
      <div style={{ position: "absolute", width: "100%", height: "100%", backgroundColor: "rgba(0,0,0,0.4)"}}>
      <Card
        style={{
          position: "absolute",
          zIndex: 10,
          top: "5%",
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
              {this.props.data ? "Update" : "Create"} Offer
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
                onChange={(name) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      name: name.target.value,
                    },
                  });
                }}
                value={this.state.data.name}
                placeholder="Offer Name"
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
                width: 200,
                marginBottom: 25,
                display: "flex",
                alignItems: "center",
                padding: "0px 20px 0px 20px",
              }}
            >
              <FontAwesomeIcon className="icon" color="#27ae61" icon={faInfoCircle} />
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
                icon={faSortNumericUpAlt}
              />
              <FormInput
                onChange={(offerCode) => {
                  this.setState({
                    data: {
                      ...this.state.data,
                      offerCode: offerCode.target.value,
                    },
                  });
                }}
                value={this.state.data.offerCode}
                placeholder="Offer Code"
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
                icon={faStar}
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
                icon={faInfoCircle}
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
                icon={faBuilding}
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
                onChange={(image) => {
                  this.setState({
                    data: { ...this.state.data, image: image.target.value },
                  });
                }}
                value={this.state.data.image}
                placeholder="Image Link"
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
          ? `${API}offers?id=${this.state.data.docID}`
          : `${API}offers`,
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

export default OfferCreate;
