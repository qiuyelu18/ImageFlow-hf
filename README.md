# ImageFlow - Hugging Face Space 部署指南

这是 [ImageFlow](https://github.com/Yuri-NagaSaki/ImageFlow) 在 Hugging Face Space 上的部署配置。ImageFlow 是一个高效智能的图像管理和分发系统，能够自动优化图像格式和尺寸，支持WebP和AVIF等现代图像格式。

## 部署步骤

1. 在 Hugging Face 上创建一个新的 Space
2. 选择 Docker 作为 Space SDK
3. 上传此目录中的文件

## 环境变量配置

在 Hugging Face Space 的设置中配置以下必要的环境变量：

| 环境变量 | 说明 | 默认值 |
|---------|------|-------|
| `API_KEY` | API密钥，用于验证上传和管理操作 | (必须设置) |
| `STORAGE_TYPE` | 存储类型：local（本地存储）或s3（S3兼容存储） | local |
| `LOCAL_STORAGE_PATH` | 本地存储路径 | /app/static/images |
| `MAX_UPLOAD_COUNT` | 单次最大上传数量 | 20 |
| `IMAGE_QUALITY` | 图像质量（1-100） | 80 |
| `WORKER_THREADS` | 并行处理线程数 | 4 |
| `COMPRESSION_EFFORT` | 压缩级别（1-10） | 6 |
| `FORCE_LOSSLESS` | 是否强制无损压缩 | false |

如果使用S3兼容存储，还需要设置以下环境变量：

| 环境变量 | 说明 |
|---------|------|
| `S3_ENDPOINT` | S3端点地址 |
| `S3_REGION` | S3区域 |
| `S3_ACCESS_KEY` | 访问密钥 |
| `S3_SECRET_KEY` | 访问密钥密文 |
| `S3_BUCKET` | 存储桶名称 |
| `CUSTOM_DOMAIN` | 自定义域名（可选） |

## 访问应用

部署完成后，可以通过 Hugging Face Space 提供的URL访问应用。默认端口为8686，应包含以下功能：

- 图片上传页面：访问 `/` 
- 图片管理页面：访问 `/manage`
- 随机图片API：访问 `/api/random`

## 数据持久化

请注意，Hugging Face Space 的容器存储是临时的，若使用本地存储模式，重启容器后数据将丢失。
建议使用S3兼容存储以确保数据持久化。

## 原始项目

更多关于 ImageFlow 的信息，请访问[原始GitHub仓库](https://github.com/Yuri-NagaSaki/ImageFlow)。 