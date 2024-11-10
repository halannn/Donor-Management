import express from "express";
import {
  createFacilitator,
  deleteFacilitator,
  getFacilitator,
  getFacilitatorById,
  getFacilitatorByType,
  getFacilitatorDonor,
  getFacilitatorStock,
  getFacilitatorTransfusion,
  updateFacilitator,
} from "../controller/facilitator.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/stock").get(getFacilitatorStock);
router.route("/donor").get(getFacilitatorDonor);
router.route("/transfusion").get(getFacilitatorTransfusion);

router
  .route("/:id")
  .get(getFacilitatorById)
  .put(updateFacilitator)
  .delete(deleteFacilitator);

router.route("/type/:type").get(getFacilitatorByType);

router.route("/").get(getFacilitator).post(createFacilitator);

export default router;
