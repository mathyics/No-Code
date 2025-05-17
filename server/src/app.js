import express, { urlencoded } from "express"
import cookieParser from "cookie-parser"
import cors from "cors"



const app = express()

//CORS Middle ware

app.use(
    cors(//allow access for all
        {
            origin: process.env.CORS_ORIGIN
        }
    )
)


//Allow json data transfer within app

app.use(
    express.json(
        
    )
)

//to make constant routs like some take %20, some take +, we ensure constant
app.use(
    express.urlencoded(
        {
            extended:true,
        }
    )
)


//direct fetchable files
app.use(
    express.static(
        "public"
    )
)

app.use(
    cookieParser(

    )
)

//configuring routes
import { userRouter } from "./routes/_01_user.routes.js"
app.use('/api/users',userRouter);


import { videoRouter } from "./routes/_02_video.routes.js"
app.use('/api/videoService',videoRouter);

export {app}