import express from "express";
import {
  createFacilitator,
  deleteFacilitator,
  readFacilitator,
  readFacilitatorByType,
  readFacilitatorDonor,
  readFacilitatorStock,
  readFacilitatorTransfusion,
  updateFacilitator,
} from "../controller/facilitator.js";
import { verifyUser, verifyAdmin } from "../middleware/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router
  .route("/")
  .get(verifyUser, readFacilitator)
  .post(verifyAdmin, createFacilitator);

router.route("/stock").get(readFacilitatorStock);
router.route("/donor").get(readFacilitatorDonor);
router.route("/transfusion").get(readFacilitatorTransfusion);
router.route("/type").get(readFacilitatorByType);

router
  .route("/:id")
  .get(readFacilitator)
  .put(updateFacilitator)
  .delete(deleteFacilitator);

export default router;
