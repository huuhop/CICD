# Sử dụng node:16-alpine để giảm kích thước image
FROM node:16-alpine

# Thiết lập thư mục làm việc trong container
WORKDIR /usr/src/app

# Sao chép package.json và package-lock.json vào container
COPY package*.json ./

# Cài đặt dependencies
RUN npm install

# Sao chép mã nguồn vào container (sử dụng .dockerignore để loại trừ file không cần thiết)
COPY . .

# Build ứng dụng NestJS
RUN npm run build

# Mở cổng 3000 để ứng dụng có thể truy cập từ ngoài container
EXPOSE 3000

# Lệnh khởi động ứng dụng NestJS trong chế độ sản xuất
CMD ["npm", "run", "start:prod"]