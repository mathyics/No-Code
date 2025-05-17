import multer from "multer";//multer will help us to upload the file using cludinary service

const storage = multer.diskStorage({
  destination: function (req, file, cb) {//cb means callback function
    console.log("file is uploading ", file);
    cb(null, "./public/cloudinary_uploads")// i will stoer those uploads here
  },
  filename: function (req, file, cb) {

    cb(null, file.originalname)
  }
})

export const upload = multer({
  storage, //we will store tht file in local storage first and then upload it to cloudinary
  limits: {
    fileSize: 100 * 1024 * 1024 // 100 MB
  },
  fileFilter: function (req, file, cb) {
    console.log("MIME TYPE:", file.mimetype);
    if (file.mimetype.startsWith("image") || file.mimetype.startsWith("video")) {
      cb(null, true);
    } else {
      console.error("Rejected file:", file.originalname, "with type:", file.mimetype);
      cb(new Error("File type not supported"), false);
    }
  }

})