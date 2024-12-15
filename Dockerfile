# Use Node.js base image
FROM node:20-alpine

# Install required OS dependencies
RUN apk add --update libc6-compat python3 make g++ \
    && apk add --no-cache build-base cairo-dev pango-dev \
    && apk add --no-cache chromium

# Install pnpm globally
RUN npm install -g pnpm

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set Node options
ENV NODE_OPTIONS=--max-old-space-size=8192

# Set the working directory
WORKDIR /usr/src

# Copy only package files for caching dependencies
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the application source code
COPY . .

# Build the project
RUN pnpm build

# Expose the application port
EXPOSE 3000

# Start the application
CMD [ "pnpm", "start" ]

