import express from "express";
import {
  createFacilitator,
  deleteFacilitator,
  getFacilitator,
  getFacilitatorByType,
  getFacilitatorDonor,
  getFacilitatorStock,
  getFacilitatorTransfusion,
  updateFacilitator,
} from "../controller/facilitator.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(getFacilitator).post(createFacilitator);

router.route("/stock").get(getFacilitatorStock);
router.route("/donor").get(getFacilitatorDonor);
router.route("/transfusion").get(getFacilitatorTransfusion);
router.route("/type").get(getFacilitatorByType);

router
  .route("/:id")
  .get(getFacilitator)
  .put(updateFacilitator)
  .delete(deleteFacilitator);

export default router;
