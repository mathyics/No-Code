import mongoose ,{ Schema } from "mongoose"


const subscriptionSchema=new Schema(
    {
        subscriber:{//who subscribed
            type:Schema.Types.ObjectId,
            ref:"User"
        },
        channel:{//to whcih chaneel subscribed
            type:Schema.Types.ObjectId,
            ref:"User"
        }
    },
    {
        timestamps:true,
    }
)


export const Subscription=mongoose.model("Subscription",subscriptionSchema)


