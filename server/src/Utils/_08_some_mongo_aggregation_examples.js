/*[
  {
    "_id": {
      "$oid": "681b4849995d33c7b494580a"
    },
    "userName": "suhail",
    "email": "suhailsharieffsharieff@gmail.com",
    "fullName": "Suhail Beta",
    "avatar": "http://res.cloudinary.com/diioxxov8/image/upload/v1746689778/j39fjsnrsg3knsvhuvjy.png",
    "coverImage": "http://res.cloudinary.com/diioxxov8/image/upload/v1746618441/trdzp2sfy0oupddvaftn.jpg",
    "password": "$2b$10$CZaKeNYM5HVTjlJxds4wBOIsG.B4cn81tKuBWHal.cbRrG7g8y04y",
    "createdAt": {
      "$date": "2025-05-07T11:47:21.772Z"
    },
    "updatedAt": {
      "$date": "2025-05-08T07:36:19.384Z"
    },
    "__v": 0,
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODFiNDg0OTk5NWQzM2M3YjQ5NDU4MGEiLCJpYXQiOjE3NDY2ODc3NzYsImV4cCI6MTc0NzI5MjU3Nn0.BOJitNQxmLIDEpdtcW5B8xlM6tDF0XAD8k59j2flqhw"
  }
]*/
// The current database to use.
use("test");


//$group
db.getCollection("users")
    .aggregate(
        [
            {
                $group: {
                    _id: "$email",
                    fullDetails: {
                        $push: {
                            fullNameEntered: "$fullName",
                            emailEntered: "$email"
                        }
                    }
                }
            }
        ]
    )

//$match
db.getCollection("users")
    .aggregate([
        {
            $match: {
                $and:[
                    {
                        email: "suhailsharieffsharieff@gmail.com"
                    },
                    {
                        fullName:"Suhail Beta"
                    }
                ]
            }
        },
        {
            $group: {
                _id: "$fullName",
            },
        },
        {
            $count:"nItems"
        }
    ]);

    //$sort
    db.getCollection("users")
    .aggregate(
        [
            //stage 1
            {
                $sort:{
                    age:-1,//first sort age descending
                    country:1//second sort age in ascending
                }
            },
        ]
    )


    //$project, allow us to decide which feilds to include and wchih to exclude
    db.getCollection("users")
    .aggregate(
        [
            {
                $project: {
                    email:0,//means give all fields except email(when below is commented)
                    // fullName:1,
                    // myFullName:"$fullName"
                }
            }
        ]
    )

    //$limit
    db.getCollection("users")
    .aggregate(
        [
            {
                $limit: 1
            }
        ]
    )


    //$unwind: for ex u have arr=[a,b,c], when u try grouping it will give unique arrays, but what if i have so many ppl and each has some array, i want to group unique from all ppl's arrays, idea is to unwind fist and then grp
    //https://www.youtube.com/watch?v=Bh6VtWxfOrI&list=PLWkguCWKqN9OwcbdYm4nUIXnA2IoXX0LI&index=30
    db.getCollection("users")
    .aggregate([
        {
            $unwind: {
              path: "$watchHistory",
              preserveNullAndEmptyArrays: true
            }
        }
    ])
