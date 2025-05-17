import mongoose from "mongoose";
import dotenv from "dotenv";
import { DB_NAME } from "./_02_constants.utils.js";
dotenv.config();


const connect_To_DB = async () => {
    try {
        const str=`${process.env.MONGO_URI}/${DB_NAME}`;
        console.log(`DB URL: ${str}`);
        
        await mongoose.connect(str);
        console.log("DB connected");
    } catch (error) {
        console.error("DB connection error:", error.message);
        process.exit(0);
    }
};

export default connect_To_DB;