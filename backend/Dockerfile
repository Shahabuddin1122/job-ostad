# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker's caching
COPY package*.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy the entire application source code
COPY . .

# Expose the application's port
EXPOSE 5000

# Define the command to run the application
CMD ["node", "src/cluster.js"]
