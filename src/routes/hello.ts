import { NextFunction, Request, Response, Router } from "express";
import { RouteInitializer, VIEWS_ROOT_DIR } from "./model";

const ROUTE_PREFIX = "/hello"
const VIEWS_DIR = VIEWS_ROOT_DIR + ROUTE_PREFIX

export class HelloRouteInitializer implements RouteInitializer {
  initialize(router: Router) {
    router.get(`${ROUTE_PREFIX}`, (req: Request, res: Response, next: NextFunction) => {
      res.sendFile(`${VIEWS_DIR}/index.html`)
    });
  }
}

