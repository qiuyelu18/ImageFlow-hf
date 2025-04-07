FROM golang:1.22-alpine AS backend-builder

WORKDIR /app

RUN apk add --no-cache git

# 克隆ImageFlow项目
RUN git clone https://github.com/Yuri-NagaSaki/ImageFlow .

# 构建后端
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o imageflow

FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

# 复制前端文件
COPY --from=backend-builder /app/frontend/ ./

# 安装依赖并构建
RUN npm install
RUN npm run build

FROM alpine:latest

WORKDIR /app

# 安装必要的依赖
RUN apk add --no-cache \
    ca-certificates \
    libwebp-tools \
    libavif-apps

# 创建必要的目录结构
RUN mkdir -p /app/static/images/metadata && \
    mkdir -p /app/static/images/original/landscape && \
    mkdir -p /app/static/images/original/portrait && \
    mkdir -p /app/static/images/landscape/webp && \
    mkdir -p /app/static/images/landscape/avif && \
    mkdir -p /app/static/images/portrait/webp && \
    mkdir -p /app/static/images/portrait/avif && \
    mkdir -p /app/favicon

# 从构建阶段复制文件
COPY --from=backend-builder /app/imageflow /app/
COPY --from=backend-builder /app/config /app/config
COPY --from=backend-builder /app/favicon /app/favicon
COPY --from=frontend-builder /app/frontend/out /app/static

# 设置默认环境变量（这些会被Hugging Face Space的环境变量设置覆盖）
ENV STORAGE_TYPE="local"
ENV LOCAL_STORAGE_PATH="/app/static/images"
ENV MAX_UPLOAD_COUNT="20"
ENV IMAGE_QUALITY="80"
ENV WORKER_THREADS="4"
ENV COMPRESSION_EFFORT="6"
ENV FORCE_LOSSLESS="false"

# 确保Hugging Face可以使用正确的端口
ENV PORT=8686
EXPOSE 8686

# 启动命令
CMD ["./imageflow"] 