import { Router } from "express"
import { registerUser,loginUser, logoutUser, refreshAccessToken, updatePassword, updateFullName, updateUserAvatar, updateUserCoverImage, getChannelInfo, getWatchHistory } from "../controller/_01_user.controller.js"
import {upload} from "../middleware/_01_multer.middle_ware.js"
import { verifyJWT } from "../middleware/_02_auth.middleware.js";

const userRouter=Router()


userRouter
.route( '/register')
.post(
    upload.fields(//middle ware, before registering pls add fields called avatar and coverImage in request, so that we can access later like req.body.avatar[0].path
        [
            {
                name:"avatar",
                maxCount:1,
            },
            {
                name:"coverImage",
                maxCount:1,
            }
        ]
    ),
    registerUser
);

//to apply jswt verify on all routs just say router.use(verifyjwt), then can use normal post without jwt middle ware

userRouter
.route('/login')
.post(
    loginUser,
)

userRouter
.route('/logout')
.post(
    verifyJWT,//middleware to append user field to req after matching actuall  accessToken and accessToken passed to req with cookie
    logoutUser
)

userRouter
.route("/refreshAccessToken")
.post(
    refreshAccessToken
)


userRouter
.route('/updatePassword')
.post(
    verifyJWT,updatePassword
)

userRouter.
route('/updateFullName')
.post(
    verifyJWT,updateFullName
)

userRouter.put("/updateAvatar", verifyJWT, upload.single("avatar"), updateUserAvatar);
userRouter.put("/updateCoverImage", verifyJWT, upload.single("coverImage"), updateUserAvatar);

userRouter
.route('/getChannelInfo/:userName')
.post(
    getChannelInfo
)


userRouter
.route('/getWatchHistory')
.get(
    verifyJWT,getWatchHistory
)

export {userRouter}