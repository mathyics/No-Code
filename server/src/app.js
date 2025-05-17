import express from "express"
import cookieParser from "cookie-parser"
import cors from "cors"
import userRouter from "./routes/_01_user.routes.js"
import symptomRouter from "./routes/symptom.routes.js"
import healthTrendRouter from "./routes/health-trend.routes.js"

const app = express()

//CORS Middle ware
app.use(
    cors(//allow access for all
        {
            origin: process.env.CORS_ORIGIN,
            credentials: true
        }
    )
)

//Allow json data transfer within app
app.use(
    express.json(
        {
            limit: "16kb"
        }
    )
)

//to make constant routs like some take %20, some take +, we ensure constant
app.use(
    express.urlencoded(
        {
            extended: true,
            limit: "16kb"
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
    cookieParser()
)

//configuring routes
app.use('/api/v1/users', userRouter)
app.use('/api/v1/symptoms', symptomRouter)
app.use('/api/v1/health', healthTrendRouter)

// Basic health check endpoint
app.get("/health", (_, res) => {
    res.status(200).json({ status: "ok", message: "Server is healthy" })
})

export { app }