# Multi-stage build for Jekyll + Tailwind CSS
FROM node:24.19.0-bookworm-slim AS node
FROM ruby:4.0.6-slim-bookworm AS base

# Install essential dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install the same Node.js release used by CI
COPY --from=node /usr/local/ /usr/local/

WORKDIR /site

# Copy dependency files
COPY Gemfile* ./
COPY package*.json ./

# Install Ruby gems
RUN bundle install

# Install npm packages
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port for Jekyll server
EXPOSE 4000

# Default command
CMD ["bash", "-c", "npm run build:css && bundle exec jekyll serve --host 0.0.0.0 --livereload --force_polling"]
