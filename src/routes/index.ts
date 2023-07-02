import express, { Router } from "express"
import { HelloRouteInitializer } from "./hello";
import { RouteInitializer } from "./model";
import { TestRouteInitializer } from "./test";

function initializeRouter(): Router {
  const router = express.Router();
  const initializers: RouteInitializer[] = [
    new HelloRouteInitializer(),
    new TestRouteInitializer(),
  ]

  initializers.forEach(obj => obj.initialize(router))
  return router
}

const router = initializeRouter()
export default router
