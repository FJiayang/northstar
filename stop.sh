#!/bin/bash

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Northstar 量化交易平台 Docker 停止脚本"
echo "=========================================="
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker 未安装${NC}"
    exit 1
fi

# 检查配置文件是否存在
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}错误: docker-compose.yml 文件不存在${NC}"
    exit 1
fi

# 检查服务是否正在运行
if ! docker compose ps | grep -q "northstar"; then
    echo -e "${YELLOW}Northstar 服务未运行${NC}"
    exit 0
fi

# 显示当前运行状态
echo -e "${YELLOW}当前运行状态:${NC}"
docker compose ps
echo ""

# 停止服务
echo -e "${YELLOW}正在停止 Northstar 服务...${NC}"
docker compose down

# 等待服务停止
sleep 5

echo ""
echo "=========================================="
echo -e "${GREEN}Northstar 服务已停止${NC}"
echo "=========================================="
echo ""
echo "如需重新启动，请运行:"
echo "  ./start.sh"
echo ""
