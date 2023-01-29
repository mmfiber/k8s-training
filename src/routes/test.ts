import { NextFunction, Request, Response, Router } from "express";
import { RouteInitializer } from "./model";

const ROUTE_PREFIX = "/test"

export class TestRouteInitializer implements RouteInitializer {
  initialize(router: Router) {
    router.get(`${ROUTE_PREFIX}/high_cpu_usage`, (req: Request, res: Response, next: NextFunction) => {
      let x = 0.0001;
      for (let i=0; i <= 1000000; i++) {
        x += Math.sqrt(x);
      }
      res.send("OK!")
    });
  }
}

