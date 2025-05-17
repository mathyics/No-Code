import { asyncHandler } from "../Utils/_03_asyncHandler.utils.js";
import { ApiError } from "../Utils/_04_Api_Error.utils.js"
import { User } from "../models/_01_user.model.js"
import { uploadOnCloudinary } from "../Utils/_06_cloudinary.file_uploading.util.js";
import { ApiResponse } from "../Utils/_05_Api_Response.utils.js";
import { get_refresh_access_token } from "../Utils/_07_token_generator.utils.js";
import { v2 as cloudinary } from "cloudinary"
import { Video } from "../models/_02_video.model.js";
import mongoose from "mongoose";
/*
user schema:
 userName: {
            type: String,
            required: true,
            unique: true,
            lowercase: true,
            trim: true, 
            index: true
        },
        email: {
            type: String,
            required: true,
            unique: true,
            lowecase: true,
            trim: true, 
        },
        fullName: {
            type: String,
            required: true,
            trim: true, 
            index: true
        },
        avatar: {
            type: String, // cloudinary url
            required: true,
        },
        coverImage: {
            type: String, // cloudinary url
        },
        watchHistory: [
            {
                type: Schema.Types.ObjectId,
                ref: "Video"
            }
        ],
        password: {
            type: String,
            required: [true, 'Password is required']
        },
        refreshToken: {
            type: String
        }
*/

const registerUser = asyncHandler(
    //steps: getAsJson->validate->checkIfAlreadyExists->ifNotThenTakeAvatar->UploadToCLpudinary->PutInMongoose
    async (req, res) => {

        //step0: upload avatar, done as middleware  
        console.log("Receiving request body.....");
        const { userName, fullName, email, password } = req.body;
        console.log(`recived body for post method register: ${JSON.stringify(req.body)}`);

        //step1: validate if feilds r not empty
        if (
            [userName, fullName, email, password]
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

        //multer has now added file in req.body, lets access it to register user
        //step3: upload avatar to clodinary
        console.log("Uploading avatar and coverImage to cloudinary.....");
        const avatarImgLocalPath = req.files?.avatar[0]?.path
        let coverImgLocalPath;
        if (req.files && Array.isArray(req.files.coverImage) && req.files.coverImage.length > 0) {//coz i have not made mandatory to compulsorily pass coverImg
            coverImgLocalPath = req.files.coverImage[0].path
        }
        console.log(`paths received from multer:\n avatar:${avatarImgLocalPath} \n coverImage:${coverImgLocalPath}`);

        //check if files r not null
        if (!avatarImgLocalPath) throw new ApiError(400, "Avatar Image is required!")
        const avatarUploaded = await uploadOnCloudinary(avatarImgLocalPath)
        if (!avatarUploaded) throw new ApiError(400, "Failed to upload avatar Image!")
        const coverImgUploaded = await uploadOnCloudinary(coverImgLocalPath)
        console.log("Images uploaded to clodinary...");

        //now files r uploaded to cloudinary
        //step4: all things r goin good, register user into database
        console.log("Registering user in MongoDB....");
        const userCreatedInDB = await User.create(
            {
                avatar: avatarUploaded.url,
                coverImage: coverImgUploaded?.url || "",
                fullName: fullName,
                userName: userName.toLowerCase(),
                email: email,
                password: password,

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

        /*
          If evrything works fine the response should look like this:
          {
      "statusCode": 200,
      "data": {
          "_id": "681b45b8c04494d446fe1294",
          "userName": "suhail",
          "email": "suhailsharieffsharieff@gmail.com",
          "fullName": "Suhail Sharieff",
          "avatar": "http://res.cloudinary.com/diioxxov8/image/upload/v1746617783/wkmwdakaeeajmpbrg3ga.png",
          "coverImage": "http://res.cloudinary.com/diioxxov8/image/upload/v1746617784/dn1goblnqyw3by2zhrpi.jpg",
          "watchHistory": [],
          "createdAt": "2025-05-07T11:36:24.935Z",
          "updatedAt": "2025-05-07T11:36:24.935Z",
          "__v": 0
      },
      "message": "User created succeesfully: User: {\"_id\":\"681b45b8c04494d446fe1294\",\"userName\":\"suhail\",\"email\":\"suhailsharieffsharieff@gmail.com\",\"fullName\":\"Suhail Sharieff\",\"avatar\":\"http://res.cloudinary.com/diioxxov8/image/upload/v1746617783/wkmwdakaeeajmpbrg3ga.png\",\"coverImage\":\"http://res.cloudinary.com/diioxxov8/image/upload/v1746617784/dn1goblnqyw3by2zhrpi.jpg\",\"watchHistory\":[],\"createdAt\":\"2025-05-07T11:36:24.935Z\",\"updatedAt\":\"2025-05-07T11:36:24.935Z\",\"__v\":0}",
      "success": true
  }
        */
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

        /**Suceess full response would look like this:
         {"statusCode":200,"data":{"user":{"_id":"681b4849995d33c7b494580a","userName":"suhail","email":"suhailsharieffsharieff@gmail.com","fullName":"Suhail Sharieff","avatar":"http://res.cloudinary.com/diioxxov8/image/upload/v1746618440/w6zl3q4qbnulzk4yyjn7.png","coverImage":"http://res.cloudinary.com/diioxxov8/image/upload/v1746618441/trdzp2sfy0oupddvaftn.jpg","watchHistory":[],"password":"$2b$10$CZaKeNYM5HVTjlJxds4wBOIsG.B4cn81tKuBWHal.cbRrG7g8y04y","createdAt":"2025-05-07T11:47:21.772Z","updatedAt":"2025-05-07T11:47:21.772Z","__v":0}},"message":"Login Sucessfull!","success":true} 
         
         */

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


const updateUserAvatar = asyncHandler(async (req, res) => {
    const avatarLocalPath = req.file?.path;

    if (!avatarLocalPath) {
        throw new ApiError(400, "Avatar file is missing");
    }

    // Step 1: Retrieve the user's current avatar URL
    const user = await User.findById(req.user?._id);
    if (!user) {
        throw new ApiError(404, "User not found");
    }

    const oldAvatarUrl = user.avatar;

    // Step 2: Extract the public_id from the old avatar URL
    const publicId = oldAvatarUrl
        ? oldAvatarUrl.split('/').slice(-1)[0].split('.')[0] // Extract public_id from URL
        : null;

    // Step 3: Delete the old image from Cloudinary
    if (publicId) {
        console.log(`Deleting old avatar with public_id: ${publicId}`);
        await cloudinary.uploader.destroy(publicId, (error, result) => {
            if (error) {
                console.error("Error deleting old avatar:", error);
            } else {
                console.log("Old avatar deleted successfully:", result);
            }
        });
    }

    // Step 4: Upload the new avatar to Cloudinary
    const avatar = await uploadOnCloudinary(avatarLocalPath);

    if (!avatar.url) {
        throw new ApiError(400, "Error while uploading new avatar");
    }

    // Step 5: Update the user's avatar in the database
    const updatedUser = await User.findByIdAndUpdate(
        req.user?._id,
        {
            $set: {
                avatar: avatar.url,
            },
        },
        { new: true }
    ).select("-password");

    return res
        .status(200)
        .json(
            new ApiResponse(200, updatedUser, "Avatar image updated successfully")
        );
});
const updateUserCoverImage = asyncHandler(async (req, res) => {
    const coverLocalPath = req.file?.path;

    if (!coverLocalPath) {
        throw new ApiError(400, "Cover image file is missing");
    }

    // Step 1: Retrieve the user's current avatar URL
    const user = await User.findById(req.user?._id);
    if (!user) {
        throw new ApiError(404, "User not found");
    }

    const oldAvatarUrl = user.coverImage;

    // Step 2: Extract the public_id from the old avatar URL
    const publicId = oldAvatarUrl
        ? oldAvatarUrl.split('/').slice(-1)[0].split('.')[0] // Extract public_id from URL
        : null;

    // Step 3: Delete the old image from Cloudinary
    if (publicId) {
        console.log(`Deleting old cover image with public_id: ${publicId}`);
        await cloudinary.uploader.destroy(publicId, (error, result) => {
            if (error) {
                console.error("Error deleting old image:", error);
            } else {
                console.log("Old cverimg deleted successfully:", result);
            }
        });
    }

    // Step 4: Upload the new avatar to Cloudinary
    const avatar = await uploadOnCloudinary(coverLocalPath);

    if (!avatar.url) {
        throw new ApiError(400, "Error while uploading new cover img");
    }

    // Step 5: Update the user's avatar in the database
    const updatedUser = await User.findByIdAndUpdate(
        req.user?._id,
        {
            $set: {
                avatar: avatar.url,
            },
        },
        { new: true }
    ).select("-password");

    return res
        .status(200)
        .json(
            new ApiResponse(200, updatedUser, "Cover image updated successfully")
        );
});


//---------APi for getting channel details, the frontend guy needs to pass userName as params in url
const getChannelInfo = asyncHandler(
    async (req, res) => {
        const { userName } = req.params
        console.log("Channel details requested...");
        if (!userName) {
            throw new ApiError(400, "No userName params provided in URL!")
        }
        console.log(`Building api body for ${userName} using mongoose aggregate pipelines....`);
        const channelDetails = await User.aggregate(

            [
                //stage 1: fetch user from userName
                { $match: { userName: "suhail" } },

                //stage 2: get nSubscribers from subscriptions collection
                {
                    $lookup: {
                        from: "subscriptions",
                        localField: "_id",
                        foreignField: "subscriber",
                        as: "mySubscribers"
                    }
                },

                //stage 3: get nSubscribed
                {
                    $lookup: {
                        from: "subscriptions",
                        localField: "_id",
                        foreignField: "channel",
                        as: "iSubscribedTo"
                    }
                },

                //stage 4: project both new feilds
                {
                    $addFields: {
                        nSubscribers: {
                            $size: "$mySubscribers"
                        },
                        nSubscribed: {
                            $size: "$iSubscribedTo"
                        },
                        haveISubscribedAlready: {
                            $cond: {
                                if: { $in: ["$id", "$iSubscribedTo.channel"] },
                                then: true,
                                else: false
                            }
                        }
                    }
                },

                //stage 5: now have appended nSubscribers and nSubscribed, lets decide what ro send to frontend
                {
                    $project: {
                        channelName: "$fullName",
                        nSubscribers: 1,
                        nSubscribed: 1,
                        haveISubscribedAlready: 1,
                        avatar: 1,
                        coverImage: 1,
                        email: 1
                    }
                }
            ]

        )

        console.log(`generated response about channel is: ${JSON.stringify(channelDetails[0])}`);

        return res
            .status(200)
            .json(
                new ApiResponse(
                    200,
                    channelDetails[0],
                    "Channel details received!"
                )
            )
    }
)


//---------get meth watchHisty

//in front end, when user will clik on watch hustory he needs to know, [that video ke owner ka {fullName,userName,avatar}] and also [that video ka {thumbnail,title,description}]

//flow: [videos collection ko join karlo using lookup] -> [fetch All video Ke REFERENCE stored in watchHistoryArray of user -> us refrence se owner dhoond nikalo jo ki REFER karta ha ek user ko -> us user ka full name , userName aur avatar nikalo -> add kardo feilds be using addFields] -> [ab video ka thubmnail, desc, title nakalo ] -> project kardo

//how?: "users" has watchHistory array field each elemnt of it refrences video as perschema

const getWatchHistory = asyncHandler(//make sure u pass verifyJWT as middleware first so that now req has user field and u can access user using req.user
    async (req, res) => {
        if (!req.user) {
            throw new ApiError(400, "Unauthrized access to watch history!")
        }
        console.log("Trying to access watch history...");
        const { _id } = req.user;
        const watchHistory = await User.aggregate(
            [
                {
                    $match: {
                        _id: _id
                    }
                },
                {
                    $lookup: {
                        from: "videos",
                        localField: "watchHistory",
                        foreignField: "_id",
                        as: "watchHistory",
                        pipeline: [//this pipeline will retrieve the details of owner of each video id
                            {
                                $lookup: {
                                    from: "users",
                                    localField: "owner",
                                    foreignField: "_id",
                                    as: "owner",
                                    pipeline: [
                                        {
                                            $project: {
                                                fullName: 1,
                                                username: 1,
                                                avatar: 1
                                            }
                                        }
                                    ]
                                }
                            },
                            {
                                $addFields: {
                                    owner: {
                                        $first: "$owner"
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
        )
        console.log("Watch histroy fetched successfully...");
        return res
            .status(200)
            .json(
                new ApiResponse(
                    200,
                    watchHistory[0].watchHistory,
                    "Watch history fetched !"
                )
            )
    }
)




export { registerUser, loginUser, logoutUser, refreshAccessToken, updatePassword, updateFullName, updateUserAvatar, updateUserCoverImage, getChannelInfo, getWatchHistory }