import { Router } from "express";

export const VIEWS_ROOT_DIR = `${process.cwd()}/src/views`
export interface RouteInitializer {
  initialize: (router: Router) => void
}
