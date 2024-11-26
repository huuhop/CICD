# Sử dụng node:16 hoặc node:18 làm base image (Node.js v22.11.0 có thể không phổ biến trong Docker Hub nên bạn có thể sử dụng phiên bản ổn định gần nhất)
FROM node:16

# Thiết lập thư mục làm việc trong container
WORKDIR /usr/src/app

# Sao chép package.json và package-lock.json vào container
COPY package*.json ./

# Cài đặt dependencies
RUN npm install

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng NestJS
RUN npm run build

# Mở cổng 3000 để ứng dụng có thể truy cập từ ngoài container
EXPOSE 3000

# Lệnh khởi động ứng dụng NestJS trong chế độ sản xuất
CMD ["npm", "run", "start:prod"]