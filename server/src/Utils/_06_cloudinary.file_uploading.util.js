import {v2 as cloudinary} from "cloudinary"///make an account in cludinary.com and make API key and secret key and cloud name and add them in .env file
import fs from "fs"//for file storage locally
import dotenv from "dotenv";

dotenv.config();

//ham kaise file upload karege means, multer package se file upload karne ke baad, us file ko cloudinary pe upload karne ke liye ye function banaya he

cloudinary.config({ 
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME, 
  api_key: process.env.CLOUDINARY_API_KEY, 
  api_secret: process.env.CLOUDINARY_API_SECRET 
});

const uploadOnCloudinary = async (localFilePath) => {
    console.log(`Cloudinary service API keys: cloud-name:${process.env.CLOUDINARY_CLOUD_NAME}, api_key:${process.env.CLOUDINARY_API_KEY}, api-secret:${process.env.CLOUDINARY_API_SECRET}`);
    try {
        if (!localFilePath) return null
        //upload the file on cloudinary
        const response = await cloudinary.uploader.upload(localFilePath, {
            resource_type: "auto" //can be image,raw,video etc, i have set to auto
        })
        // file has been uploaded successfull
        console.log("file is uploaded on cloudinary, file_url:  ", response.url);
        fs.unlinkSync(localFilePath)//after upload , just remove again from public folder
        return response;

    } catch (error) {
        fs.unlinkSync(localFilePath) // remove the locally saved temporary file as the upload operation got failed
        console.log("Error in uploading file in cloudinary: ", error.message);
        
        return null;
    }
}



export {uploadOnCloudinary}