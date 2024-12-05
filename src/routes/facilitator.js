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

router.route("/stock").get(verifyUser, readFacilitatorStock);
router.route("/donor").get(verifyUser, readFacilitatorDonor);
router.route("/transfusion").get(verifyUser, readFacilitatorTransfusion);
router.route("/type").get(verifyUser, readFacilitatorByType);

router
  .route("/:id")
  .get(verifyUser, readFacilitator)
  .put(verifyAdmin, updateFacilitator)
  .delete(verifyAdmin, deleteFacilitator);

export default router;
