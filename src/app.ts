import express, { Express } from "express";
import path from "path";
import cookieParser from "cookie-parser";
import logger from "morgan";

import router from "./routes";

class App {
  private app: Express

  constructor() {
    this.app = express()
    this.setMiddlewares()
    this.setViews()
    this.setRoutes()
  }

  private setMiddlewares() {
    this.app.use(logger("dev"));
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: false }));
    this.app.use(cookieParser());
    this.app.use(express.static(path.join(__dirname, "public")));
  }

  private setViews() {
    this.app.set("views", path.join(__dirname, "views"));
  }

  private setRoutes() {
    this.app.use("/", router);
  }

  start() {
    const port = process.env.PORT
    this.app.listen(port, () => {
      console.log(`sample app listening on port ${port}`)
    })
  }
}

export default App
