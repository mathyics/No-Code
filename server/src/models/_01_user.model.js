import mongoose, {Schema} from "mongoose";
import jwt from "jsonwebtoken"
import bcrypt from "bcrypt"

const userSchema = new Schema(
    {
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

    },
    {
        timestamps: true
    }
)
//pre matlab, koi bhi data ko save karne se pehle ye function run karlo
userSchema.pre("save", async function (next) {
    if(!this.isModified("password")) return next();//save karne se pehle deklo if password is same as bfr or not

    this.password = await bcrypt.hash(this.password, 10);//password change hua he, to hash kar do aur next movve karo for abt 10 rounds of security
    next();
})


//we can create our own utility methods, syntax: userSchema.methods.methodName = function(){}

userSchema.methods.isPasswordCorrect = async function (password) {
    try {
        console.log(`Comparing entered password with stored hash...`);
        const isMatch = await bcrypt.compare(password, this.password);
        console.log(`Password match result: ${isMatch}`);
        return isMatch;
    } catch (error) {
        console.error("Error comparing passwords:", error);
        return false;
    }
};

userSchema.methods.generateAccessToken = function(){
    return jwt.sign(
        {
            _id: this._id,
            email: this.email,
            username: this.username,
            fullName: this.fullName
        },
        process.env.ACCESS_TOKEN_SECRET,
        {
            expiresIn: process.env.ACCESS_TOKEN_EXPIRY
        }
    )
}
userSchema.methods.generateRefreshToken = function(){
    return jwt.sign(
        {
            _id: this._id,
            
        },
        process.env.REFRESH_TOKEN_SECRET,
        {
            expiresIn: process.env.REFRESH_TOKEN_EXPIRY
        }
    )
}

export const User = mongoose.model("User", userSchema)