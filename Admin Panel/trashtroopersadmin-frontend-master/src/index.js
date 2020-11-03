import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";

console.log = ()=>{}
console.warn = ()=>{}
console.error = ()=>{}

ReactDOM.render(
  <React.StrictMode>
    <link
      href="https://fonts.googleapis.com/css?family=Lato&subset=latin,latin-ext"
      rel="stylesheet"
      type="text/css"
    ></link>
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
