#Builder
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

#Runtime
FROM nginxinc/nginx-unprivileged:1.27-alpine AS runtime

ENV BACKEND_UPSTREAM=http://backend:3000

COPY nginx.conf /etc/nginx/templates/default.conf.template 
COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html

USER nginx
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]