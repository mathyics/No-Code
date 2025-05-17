import "mongoose"
import { asyncHandler } from "../Utils/_03_asyncHandler.utils.js"
import { ApiError } from "../Utils/_04_Api_Error.utils.js";
import { Video } from "../models/_02_video.model.js";
import { uploadOnCloudinary } from "../Utils/_06_cloudinary.file_uploading.util.js";
import { ApiResponse } from "../Utils/_05_Api_Response.utils.js";
import { User } from "../models/_01_user.model.js";
/*const videoSchema = new Schema(
    {
        videoFile: {
            type: String, //cloudinary url
            required: true
        },
        thumbNail: {
            type: String, //cloudinary url
            required: true
        },
        title: {
            type: String, 
            required: true
        },
        description: {
            type: String, 
            required: true
        },
        duration: {
            type: Number, 
            required: true
        },
        views: {
            type: Number,
            default: 0
        },
        isPublished: {
            type: Boolean,
            default: true
        },
        owner: {
            type: Schema.Types.ObjectId,
            ref: "User"
        },
        hashtags:[
            {
                type:String,
                required:true,
            }
        ]

    }, 
    {
        timestamps: true
    }
)
    */

const createVideo = asyncHandler(
    async (req, res) => {
        if (!req.body) {
            throw new ApiError(400, "Please provide video details");
        }
        const user = await User.findById(req.user._id)
        if (!user) {
            throw new ApiError(404, "User not found");
        }
        if (!req.files || !req.files.videoFile || !req.files.thumbNail || req.files.videoFile.length === 0 || req.files.thumbNail.length === 0) {
            throw new ApiError(400, "Videofiles are missing");
        }
        console.log("User is uploading video...");
        const videoFilePath = req.files.videoFile[0].path
        const thumbNailPath = req.files.thumbNail[0].path;

        console.log(`paths received from multer:\n videofile:${videoFilePath} \n thumbNail:${thumbNailPath}`);

        //check if files r not null
        const videoFileUploaded = await uploadOnCloudinary(videoFilePath)
        if (!videoFileUploaded) throw new ApiError(400, "Failed to upload video!")

        const thumbNailuploaded = await uploadOnCloudinary(thumbNailPath)
        if (!thumbNailuploaded) throw new ApiError(400, "Failed to upload thumbnail!")

        // console.log("Video and thumbnail uploaded to clodinary..."+JSON.stringify(videoFileUploaded));


        const { title, description } = req.body
        if (!title || !description) {
            throw new ApiError(400, "Please provide title and description");
        }
        console.log(`title: ${title} \n description: ${description}`);

        let hashTags = req.body.hashTags;

        // If hashTags is undefined, set as empty array
        if (!hashTags) {
            hashTags = [];
        } else if (Array.isArray(hashTags)) {
            // Already an array (e.g., sent as multiple form-data keys)
            hashTags = hashTags.map(tag => String(tag).trim());
        } else if (typeof hashTags === "string") {
            // Try to parse as JSON array
            try {
                const parsed = JSON.parse(hashTags);
                if (Array.isArray(parsed)) {
                    hashTags = parsed.map(tag => String(tag).trim());
                } else {
                    // Fallback: split by comma
                    hashTags = hashTags.split(',').map(tag => tag.trim());
                }
            } catch (e) {
                // Fallback: split by comma
                hashTags = hashTags.split(',').map(tag => tag.trim());
            }
        }
        console.log(`hashTags:`, hashTags);


        const video = await Video.create(
            {
                videoFile: videoFileUploaded.url,
                thumbNail: thumbNailuploaded.url,
                title: title,
                description: description,
                hashtags: hashTags,
                duration: videoFileUploaded.duration,
                owner: user._id,
            }
        )

        console.log("Video created in DB..." + JSON.stringify(video));

        return res
            .status(200)
            .json(
                new ApiResponse(
                    200,
                    video,
                    "Video created successfully",
                )
            );
    }
)


export {
    createVideo,
}