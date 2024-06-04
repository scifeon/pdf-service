FROM node:lts-alpine

ARG NODE_ENV=production

RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    font-roboto \
    font-noto \
    nodejs \
    yarn \
    fontconfig

# Copy fonts
COPY fonts/*.ttf /usr/share/fonts/
COPY fonts/*.ttf ~/.fonts

# Update font cache
RUN fc-cache -fv

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

COPY package.json /service/package.json
COPY yarn.lock /service/yarn.lock

RUN cd /service; yarn install;

RUN echo chromium-browser --version

# Copy app source
COPY . /service

# Set work directory to /api
WORKDIR /service

# set your port
ENV PORT 2305

# expose the port to outside world
EXPOSE 2305

# start command as per package.json
CMD ["node", "src/index"]