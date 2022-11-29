import express, { Router } from "express"
import { HelloRouteInitializer } from "./hello";
import { RouteInitializer } from "./model";

function initializeRouter(): Router {
  const router = express.Router();
  const initializers: RouteInitializer[] = [
    new HelloRouteInitializer(),
  ]

  initializers.forEach(obj => obj.initialize(router))
  return router
}

const router = initializeRouter()
export default router
