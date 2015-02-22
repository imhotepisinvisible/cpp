docker stop rails
docker rm rails
docker build -t rails /app
docker run -d -p 3000:3000 -v /app:/app --link redis:redis --link postgres:db --link mailcatcher:mailcatcher --name rails rails:latest