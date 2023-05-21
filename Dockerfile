FROM node:16 AS frontend

WORKDIR /var/tmp

ADD package.json .
ADD package-lock.json .

RUN npm install

RUN npx ngcc --properties es2015 browser module main --first-only --create-ivy-entry-points

ADD . .

# -c configuration (environment)
RUN npm run build -- -c production

# --- Install engineX (nginx) for middleware

FROM nginx:stable

#                    this is the anguar app       this is where nginx serves the files
COPY --from=frontend /var/tmp/dist/rpstrackerng14 /usr/share/nginx/html

# make the app accessible through port 80
EXPOSE 80
