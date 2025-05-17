import { asyncHandler } from "../Utils/_03_asyncHandler.utils.js";
import { ApiError } from "../Utils/_04_Api_Error.utils.js"
import { User } from "../models/_01_user.model.js"
import { uploadOnCloudinary } from "../Utils/_06_cloudinary.file_uploading.util.js";
import { ApiResponse } from "../Utils/_05_Api_Response.utils.js";
import { get_refresh_access_token } from "../Utils/_07_token_generator.utils.js";
import { v2 as cloudinary } from "cloudinary"
import mongoose from "mongoose";


const registerUser = asyncHandler(
    //steps: getAsJson->validate->checkIfAlreadyExists->ifNotThenTakeAvatar->UploadToCLpudinary->PutInMongoose
    async (req, res) => {

        //step0: upload avatar, done as middleware  
        console.log("Receiving request body.....");
        const { userName, fullName, email, password,contact } = req.body;
        console.log(`recived body for post method register: ${JSON.stringify(req.body)}`);

        //step1: validate if feilds r not emptyies
        if (
            [userName, fullName, email, password,contact]
                .some(
                    (e) => e?.trim() === ""
                )
        ) {
            throw new ApiError(400, "Username/Fullname/Email/Password cannot be empty !");
        }

        //now fields r valid
        //step2: check if user already exists in DB
        console.log("Checking if user already exists.....");
        const userAlreadyExists = await User.findOne({
            $or: [
                { userName: userName }, // Check if userName exists
                { email: email }        // Check if email exists
            ]
        });
        if (userAlreadyExists) {
            throw new ApiError(400, "Username/Email already exists!");
        }
        //now user is not present in DB

        console.log("Registering user in MongoDB....");
        const userCreatedInDB = await User.create(
            {
                fullName: fullName,
                userName: userName.toLowerCase(),
                email: email,
                password: password,
                contact:contact,
            }
        )

        console.log("Cheking if user is registered sucessfully....");
        //check if user created is successfulll, by finding generated id
        const user = await User.findById(
            userCreatedInDB._id
        ).select(
            "-password -refreshToken"  //try selecting all feilds except password and refreshToken
        )

        if (!user) {
            throw new ApiError(400, "Failed to register user!")
        }


        //send success reponse
        console.log(`User registered sucessfully`);
        return res
            .status(200)
            .json(
                new ApiResponse(
                    200,
                    user,
                    `User created succeesfully: User: ${JSON.stringify(user)}`
                )
            )
    }




);

//*******************LOGIN */

//checkCredentials->ifValidGenerateAnAccessTokenAndRefreshTokenWhichWeWill be using to maintain logged in user session, if user logs out we will refresh the access token, the server will compare the prev and curr since its mismatch it will make user logged out->send access token as cookie(The Cookie is a small message from a web server passed to the user's browser when you visit a website. In other words, Cookies are small text files of information created/updated when visiting a website and stored on the user's web browser. Cookies are commonly used for information about user sections, user preferences and other data on the website. Cookies help websites remember users and track their activities to provide a personalised experience)->once te user is logged in , we can access the user's details just by using these cookies that r continously carried btw server and client

const loginUser = asyncHandler(

    async (req, res) => {


        console.log("Fetching UI data for login...");
        console.log(`Body received for login: ${JSON.stringify(req.body)}`);
        const { userName, email, password } = req.body;

        if (!(password && (userName || email))) {
            throw new ApiError(400, "Invalid Credentials!")
        }

        console.log("Checking if user is registered....");

        const user = await User.findOne(
            {
                $or: [
                    { userName: userName },
                    { email: email }
                ],
            }
        )

        if (!user) {
            throw new ApiError(400, "Invalid credentials!")
        }

        console.log(`User do exists..matching password...`);
        const passwordCorrect = await user.isPasswordCorrect(password);//we have defined this method in _01_user.models.js
        if (!passwordCorrect) {
            throw new ApiError(401, "Invalid Credentials!")
        }
        console.log("User login sucess");

        console.log("Starting generation of refresh token and passing them as cookies so that user data can be accessed via cookies in logged in session...");

        const { accessToken, refreshToken } = await get_refresh_access_token(user._id)

        console.log("Sent these tokens as cookies for logged session...");

        return res
            .status(200)
            .cookie(//we have given our website cookie usng app.use(cookie-parser())
                "accessToken",
                accessToken,
                {
                    httpOnly: true,
                    secure: false
                }
            )
            .cookie(
                "refreshToken",
                refreshToken,
                {
                    httpOnly: true,
                    secure: false
                }
            )
            .json(
                new ApiResponse(
                    200,
                    {
                        user: user,
                        accessToken,//this and below is for like for ex mobile apps whcih doent use cookie
                        refreshToken
                    },
                    "Login session created!"
                )
            )

       
    }
);

//***********Logout */
//idea is how to reset refreshToken of curr user to undefined, meaninf logout usser, but but but bfr that we need to append user field to req, to do that i made a middle ware called verifyJWT in _02_auth.middleware.js, where i asked jst to verify curr access token and access token passed to cookie during login if matched it will append user field to req, now i can access user directly using req paramater, dont forget to add middle ware in routes
const logoutUser = asyncHandler(
    async (req, res) => {
        if (!req.user) {
            throw new ApiError(400, "JWT failed to append user field to request while logging out...")
        }
        console.log("User field avaliable in req now...");

        console.log("Setting access token of user to undefined bfr logout...");

        const updatedUser = await User.findByIdAndUpdate(
            req.user._id,
            {
                $unset: {
                    refreshToken: 1
                }
            },
            {
                new: true,//now this returns updated user
            }
        )

        if (!updatedUser) {
            console.error("Failed to update user refresh token.");
            throw new ApiError(500, "Failed to update user refresh token.");
        }

        console.log("Set refresh token to undefined, logout sucess..");

        return res
            .status(200)
            .clearCookie("accessToken", { httpOnly: true, secure: false })
            .clearCookie("refreshToken", { httpOnly: true, secure: false })
            .json(
                new ApiResponse(
                    200,
                    updatedUser,
                    "Logout success"
                )
            )
    }
)

const refreshAccessToken = asyncHandler(async (req, res) => {
    const incomingRefreshToken = req.cookies.refreshToken || req.body.refreshToken

    if (!incomingRefreshToken) {
        throw new ApiError(401, "unauthorized request")
    }

    try {
        const decodedToken = jwt.verify(
            incomingRefreshToken,
            process.env.REFRESH_TOKEN_SECRET
        )

        const user = await User.findById(decodedToken?._id)

        if (!user) {
            throw new ApiError(401, "Invalid refresh token")
        }

        if (incomingRefreshToken !== user?.refreshToken) {
            throw new ApiError(401, "Refresh token is expired or used")

        }

        const options = {
            httpOnly: true,
            secure: true
        }

        const { accessToken, newRefreshToken } = await generateAccessAndRefereshTokens(user._id)

        return res
            .status(200)
            .cookie("accessToken", accessToken, options)
            .cookie("refreshToken", newRefreshToken, options)
            .json(
                new ApiResponse(
                    200,
                    { accessToken, refreshToken: newRefreshToken },
                    "Access token refreshed"
                )
            )
    } catch (error) {
        throw new ApiError(401, error?.message || "Invalid refresh token")
    }

})

/**Change password functionality */
// check if same, if yes update
const updatePassword = asyncHandler(
    async (req, res) => {

        const { oldPassword, newPassword } = req.body;

        console.log("Change password method called...");

        const user = await User.findById(req.user._id);
        const validReq = await user.isPasswordCorrect(oldPassword);

        if (!validReq) {
            throw new ApiError(400, "Incorrect old password!");
        }
        console.log("Saving new password...");
        user.password = newPassword
        await user.save({ validateBeforeSave: false })
        console.log("Password reset success...");
        return res
            .status(200)
            .json(
                new ApiResponse(
                    200,
                    "Password reset success"
                )
            )
    }
)
/**Update full name func */
const updateFullName = asyncHandler(
    async (req, res) => {
        console.log("Upadate fullname method called...");
        const { newFullName } = req.body;
        if (!newFullName) {
            throw new ApiError(400, "Invalid full name!")
        }
        console.log("Updating full name....");
        const updatedUser = await User.findByIdAndUpdate(
            req.user._id,
            {
                $set: {
                    fullName: newFullName
                }
            },
            {
                new: true
            }
        )
        if (!updatedUser) {
            throw new ApiError(400, "Failed to update Full name!")
        }
        console.log("full name updated...");
        return res
            .status(200)
            .json(
                new ApiResponse(
                    200,
                    updatedUser,
                    "Full name updated suceessfully!"
                )
            )
    }
)






export { registerUser, loginUser, logoutUser, refreshAccessToken, updatePassword, updateFullName}