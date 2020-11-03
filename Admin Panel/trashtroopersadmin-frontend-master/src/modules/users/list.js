import React from "react";
import {
  faCaretDown,
  faInfoCircle,
  faMap,
  faUserFriends,
  faMapMarker,
  faTrash,
  faEdit,
  faPlusCircle,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Lottie from "lottie-react-web";
import * as loading from "../../loading.json";
import { API } from "../../constants";
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
import OfferCreate from "./create";

class UserList extends React.Component {
  state = {
    loading: true,
    page: 0,
    users: [],
    alert: {},
    previousPage: 0,
    showDeleteModal: false,
    showCreateModal: false,
    showUpdateModal: false,
    updateUser: null,
    wasLastItem: false,
  };
  async componentDidMount() {
    this.loadUsers();
  }
  render() {
    return (
      <div
        style={{
          position: "relative",
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
            {/* {this.state.showDeleteModal && (
              <div
                style={{
                  position: "absolute",
                  top: "30%",
                  left: "40%",
                  width: "40%",
                  height: 100,
                  borderRadius: 20,
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "center",
                  boxShadow: "0 0 3px black",
                  zIndex: 2,
                  backgroundColor: "white",
                }}
              >
                <p
                  style={{
                    fontSize: 14,
                    alignSelf: "flex-start",
                    marginLeft: 10,
                  }}
                >
                  Delete this mission?
                </p>
                <div
                  style={{
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                    alignSelf: "flex-end",
                  }}
                >
                  <Button
                    onClick={() => {
                      this.deleteUser();
                    }}
                    style={{
                      background: "#27ae61",
                      outline: "none",
                      borderRadius: 25,
                      border: "1px solid #27ae61",
                      boxShadow: "0 0 3px black",
                      margin: 10,
                      padding: 5,
                      cursor: "pointer",
                    }}
                  >
                    <p style={{ color: "white", padding: 5, margin: 0 }}>
                      Cancel
                    </p>
                  </Button>
                  <Button
                    onClick={() => {
                      this.deleteUser();
                    }}
                    style={{
                      background: "#27ae61",
                      outline: "none",
                      borderRadius: 25,
                      border: "1px solid #27ae61",
                      boxShadow: "0 0 3px black",
                      margin: 10,
                      padding: 5,
                      cursor: "pointer",
                    }}
                  >
                    <p style={{ color: "white", padding: 5, margin: 0 }}>
                      Delete
                    </p>
                  </Button>
                </div>
              </div>
            )} */}
            {this.state.showCreateModal && (
              <OfferCreate
                user={this.props.user}
                callback={(alert) => {
                  this.setState({ alert });
                  this.loadUsers();
                }}
                close={() => {
                  this.setState({ showCreateModal: false });
                }}
              ></OfferCreate>
            )}
            {this.state.showUpdateModal && (
              <OfferCreate
                user={this.props.user}
                callback={(alert) => {
                  this.setState({ alert });
                  this.loadUsers();
                }}
                data={this.state.updateUser}
                close={() => {
                  this.setState({ showUpdateModal: false });
                }}
              ></OfferCreate>
            )}
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
                    position: "absolute",
                    width: "100%",
                    zIndex: 100,
                  }}
                  theme={this.state.alert.theme || "warning"}
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
                width: "100%",
                maxHeight: "100%",
                overflow: "auto",
              }}
            >
              <div
                style={{
                  display: "flex",
                  flexDirection: "column",
                  justifyContent: "center",
                  alignItems: "center",
                  width: "100%",
                  //   height: window.innerHeight,
                }}
              >
                <CardTitle
                  style={{ fontSize: 22, color: "#27ae61", marginLeft: 10, textDecoration:"underline" }}
                >
                  Manage Users
                  <FontAwesomeIcon
                            className="icon"
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 20px", cursor: "pointer" }}
                            icon={faPlusCircle}
                            onClick={() => {
                              this.setState({ showCreateModal: true });
                            }}
                          />
                </CardTitle>
                {this.state.users.map((user, index) => {
                  return (
                    <div
                      key={"user" + index}
                      className="listItem"
                      style={{
                        position: "relative",
                        cursor: "pointer",
                        borderRadius: 20,
                        // border: "1px solid white",
                        boxShadow: "0 0 3px black",
                        height: 175,
                        width: "50%",
                        margin: "10px 0px 10px 0px",
                        display: "flex",
                        flexWrap: "nowrap",
                        overflow: "hidden",
                      }}
                    >
                      <div
                        style={{
                          position: "absolute",
                          right: 10,
                          top: 10,
                          display: "flex",
                          flexDirection: "column",
                        }}
                      >
                        {/* {index === 0 && (
                          <FontAwesomeIcon
                            className="icon"
                            color="#27ae61"
                            style={{ margin: "5px 0px 5px 0px" }}
                            icon={faPlusCircle}
                            onClick={() => {
                              this.setState({ showCreateModal: true });
                            }}
                          />
                        )} */}

                        <FontAwesomeIcon
                          className="icon"
                          color="#ffb400"
                          style={{ margin: "5px 0px 5px 0px" }}
                          icon={faEdit}
                          onClick={() => {
                            this.setState({
                              showUpdateModal: true,
                              updateUser: user,
                            });
                          }}
                        />
                        <FontAwesomeIcon
                          className="icon"
                          color="red"
                          style={{ margin: "50px 0px 0px 0px" }}
                          icon={faTrash}
                          onClick={() => {
                            this.deleteUser(user.uid);
                          }}
                        />
                      </div>
                      <img
                        src={user.profilePhoto}
                        style={{ width: "40%", height: "100%" }}
                      ></img>
                      <div
                        style={{
                          display: "flex",
                          height: "100%",
                          flexDirection: "column",
                        }}
                      >
                        <div
                          style={{
                            display: "flex",
                            flexWrap: "nowrap",
                            alignItems: "center",
                          }}
                        >
                          {/* <FontAwesomeIcon
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 10px" }}
                            icon={faMap}
                          /> */}
                          <p
                            style={{
                              padding: 5,
                              margin: 0,
                              fontSize: 14,
                              color: "grey",
                              fontWeight: "bold",
                            }}
                          >
                            {user.name}
                          </p>
                        </div>
                        <div
                          style={{
                            display: "flex",
                            flexWrap: "nowrap",
                            alignItems: "center",
                          }}
                        >
                          {/* <FontAwesomeIcon
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 10px" }}
                            icon={faMapMarker}
                          /> */}
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              fontWeight: "bold",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            Email:
                          </p>
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              padding: 5,
                              margin: 0,
                              maxWidth: 150,
                              textOverflow: "ellipsis",
                              overflow: "hidden",
                              whiteSpace: "nowrap",
                            }}
                          >
                            {user.email || "-"}
                          </p>
                        </div>
                        {/* <div
                          style={{
                            display: "flex",
                            flexWrap: "nowrap",
                            alignItems: "center",
                          }}
                        >
                          <FontAwesomeIcon
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 10px" }}
                            icon={faMapMarker}
                          />
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              fontWeight: "bold",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            Code:
                          </p>
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            {offer.offerCode || "-"}
                          </p>
                        </div>
                        <div
                          style={{
                            display: "flex",
                            flexWrap: "nowrap",
                            alignItems: "center",
                          }}
                        >
                          {/* <FontAwesomeIcon
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 10px" }}
                            icon={faMapMarker}
                          /> */}
                        {/* <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              fontWeight: "bold",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            Points:
                          </p>
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            {offer.points || "-"}
                          </p>
                        </div>
                        <div
                          style={{
                            display: "flex",
                            flexWrap: "nowrap",
                            alignItems: "center",
                          }}
                        > */}
                        {/* <FontAwesomeIcon
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 10px" }}
                            icon={faMapMarker}
                          /> */}
                        {/* <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              fontWeight: "bold",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            Type:
                          </p>
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            {offer.type || "-"}
                          </p>
                        </div>
                        <div
                          style={{
                            display: "flex",
                            flexWrap: "nowrap",
                            alignItems: "center",
                          }}
                        > */}
                        {/* <FontAwesomeIcon
                            color="#27ae61"
                            style={{ margin: "0px 10px 0px 10px" }}
                            icon={faMapMarker}
                          /> */}
                        {/* <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              fontWeight: "bold",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            Vendor:
                          </p>
                          <p
                            style={{
                              fontSize: 12,
                              color: "grey",
                              padding: 5,
                              margin: 0,
                            }}
                          >
                            {offer.vendor || "-"}
                          </p>
                        </div>  */}
                      </div>
                    </div>
                  );
                })}

                <div
                  style={{
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                    margin: "30px 0px 30px 0px",
                  }}
                >
                  <Button
                  className="icon"
                    disabled={!this.state.page}
                    style={{
                      border: 0,
                      boxShadow: "0 0 3px black",
                      margin: 4,
                      borderRadius: 20,
                      padding: "10px 14px 10px 14px",
                      backgroundColor: "#27ae61",
                      cursor: "pointer",
                      outline: "none",
                    }}
                    onClick={() => {
                      this.setState(
                        {
                          page: this.state.page - 1,
                          previousPage: this.state.page,
                        },
                        () => {
                          this.loadUsers();
                        }
                      );
                    }}
                  >
                    <p
                    
                      style={{
                        fontSize: 12,
                        color: "white",
                        padding: 0,
                        margin: 0,
                      }}
                    >
                      Prev
                    </p>
                  </Button>
                  <h4
                      style={{
                        padding: 0,
                        margin: "0px 10px 0px 10px",
                      }}
                    >
                      {this.state.page + 1}
                    </h4>
                  <Button
                  className="icon"
                    style={{
                      border: 0,
                      boxShadow: "0 0 3px black",
                      margin: 4,
                      borderRadius: 20,
                      padding: "10px 14px 10px 14px",
                      backgroundColor: "#27ae61",
                      cursor: "pointer",
                      outline: "none",
                    }}
                    onClick={() => {
                      this.setState(
                        {
                          page: this.state.page + 1,
                          previousPage: this.state.page,
                        },
                        () => {
                          this.loadUsers();
                        }
                      );
                    }}
                  >
                    <p
                      style={{
                        fontSize: 12,
                        color: "white",
                        padding: 0,
                        margin: 0,
                      }}
                    >
                      Next
                    </p>
                  </Button>
                </div>
              </div>
            </div>
          </>
        )}
      </div>
    );
  }

  loadUsers = async () => {
    this.setState({ loading: true });
    console.log("Page: ", this.state.page);
    try {
      let res = await fetch(
        `${API}users?offset=${this.state.page >= 0 ? this.state.page : 0}`,
        {
          method: "get",
          headers: {
            Accept: "*/*",
            Authorization: "Bearer " + this.props.user.token,
            "Content-Type": "application/json",
          },
          body: null,
        }
      );
      let data = await res.json();
      console.log(data);
      if (res.status != 200) {
        throw data;
      }

      this.setState(
        {
          loading: false,
          users: data.users,
          wasLastItem: data.users.length === 1,
        },
        () => {
          console.log("State: ", this.state);
        }
      );
    } catch (error) {
      console.log(error);
      this.setState({ loading: false, page: this.state.previousPage });
      if (error instanceof Error) {
        this.setState({
          alert: {
            message: "We encountered some connectivity issues.",
            theme: "warning",
          },
        });
        return;
      }
      this.setState({ alert: { message: error.error, theme: "danger" } });
      return;
    }
  };

  deleteUser = async (docID) => {
    this.setState({ loading: true });
    try {
      let res = await fetch(`${API}users?id=${docID}`, {
        method: "delete",
        headers: {
          Accept: "*/*",
          Authorization: "Bearer " + this.props.user.token,
          "Content-Type": "application/json",
        },
        body: null,
      });
      let data = await res.json();
      console.log(data);
      if (res.status != 200) {
        throw data;
      }
      this.setState({
        alert: {
          message: data.message,
          theme: "success",
        },
      });
      if (this.state.wasLastItem) {
        this.setState({ page: this.state.page - 1 }, () => {
          this.loadUsers();
        });
      } else this.loadUsers();
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
      this.setState({ alert: { message: error.error, theme: "danger" } });
      return;
    }
  };
}

export default UserList;
