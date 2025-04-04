const app = require("./app");
const logger = require("./config/logger");
const dotenv = require("dotenv");

dotenv.config();
const PORT = process.env.PORT || 5000;

app.listen(PORT, "0.0.0.0", () => {
  logger.info(`Server running on port ${PORT}`);
});
