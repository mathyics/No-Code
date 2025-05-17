import { Router } from "express"
import {upload} from "../middleware/_01_multer.middle_ware.js"
import { verifyJWT } from "../middleware/_02_auth.middleware.js";
import { createVideo } from "../controller/_02_video.controller.js";

const videoRouter=Router()
videoRouter.use(verifyJWT)


videoRouter
.route('/createVideo')
.post(
    upload.fields(
        [
            {
                name:"videoFile",
                maxCount:1
            },
            {
                name:"thumbNail",
                maxCount:1
            }
        ]
    ),
    createVideo
);






export {videoRouter}