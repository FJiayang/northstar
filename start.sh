#!/bin/bash

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Northstar 量化交易平台 Docker 启动脚本"
echo "=========================================="
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker 未安装${NC}"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查 Docker Compose 是否安装
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}错误: Docker Compose 未安装${NC}"
    echo "请先安装 Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# 检查配置文件是否存在
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}错误: docker-compose.yml 文件不存在${NC}"
    exit 1
fi

# 拉取最新镜像
echo -e "${YELLOW}正在拉取最新镜像...${NC}"
if docker compose pull northstar; then
    echo -e "${GREEN}镜像拉取成功${NC}"
else
    echo -e "${YELLOW}警告: 镜像拉取失败，将使用本地镜像（如果存在）${NC}"
fi
echo ""

# 创建日志目录
mkdir -p logs

# 启动服务
echo -e "${YELLOW}正在启动 Northstar 服务...${NC}"
docker compose up -d

# 等待服务启动
echo ""
echo -e "${YELLOW}等待服务启动...${NC}"
sleep 10

# 检查容器状态
echo ""
echo -e "${GREEN}检查容器状态:${NC}"
docker compose ps

echo ""
echo "=========================================="
echo -e "${GREEN}Northstar 服务已启动!${NC}"
echo "=========================================="
echo ""
echo "访问地址:"
echo "  - Web 监控台: https://localhost"
echo "  - WebSocket 端口: 51688"
echo ""
echo "默认账号:"
echo "  - 用户名: admin"
echo "  - 密码: 123456"
echo ""
echo "查看日志:"
echo "  - ./stop.sh"
echo "  - docker compose logs -f"
echo "  - tail -f logs/northstar.log"
echo ""
