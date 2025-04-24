const imgbbUploader = require("imgbb-uploader");
const dotenv = require("dotenv");

dotenv.config();

exports.imgbb = async (book_image) => {
  const response = await imgbbUploader({
    apiKey: process.env.IMGBB_API_KEY,
    base64string: book_image.buffer.toString("base64"),
  });
  return response;
};
