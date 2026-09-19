# Tiny static image: nginx + the built site. No app runtime, no secrets baked in.
FROM nginx:1.27-alpine

# Replace the stock server block with ours.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Ship the static site (index.html, graveyard.html, images/).
COPY site/ /usr/share/nginx/html/

EXPOSE 80
