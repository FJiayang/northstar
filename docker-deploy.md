# Northstar Docker 部署指南

## 快速开始

### 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- Linux/macOS/Windows (WSL2)

### 启动服务

使用启动脚本一键部署：

```bash
./start.sh
```

脚本会自动：
- 检查 Docker 环境
- 拉取最新镜像
- 启动容器
- 显示服务状态

### 停止服务

```bash
./stop.sh
```

### 手动操作（可选）

如果不想使用脚本，也可以手动操作：

```bash
# 拉取镜像
docker compose pull

# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f

# 停止服务
docker compose down
```

## 配置说明

### docker-compose.yml

```yaml
services:
  northstar:
    image: ghcr.io/fjiayang/northstar:latest  # 镜像地址
    container_name: northstar                  # 容器名称
    restart: unless-stopped                   # 自动重启策略
    ports:
      - "443:443"     # HTTPS Web 界面
      - "51688:51688" # WebSocket 端口
    environment:
      - NS_USER=admin    # 默认用户名
      - NS_PWD=123456    # 默认密码
      - TZ=Asia/Shanghai # 时区
      - JAVA_OPTS=-Xms1g -Xmx2g -XX:+UseG1GC  # JVM 参数
    volumes:
      - northstar_data:/northstar-dist/data    # 数据持久化
      - ./logs:/northstar-dist/logs            # 日志目录
```

### 自定义配置

#### 修改端口映射

编辑 `docker-compose.yml`：

```yaml
ports:
  - "8443:443"      # 将主机的 8443 映射到容器的 443
  - "61688:51688"   # 将主机的 61688 映射到容器的 51688
```

#### 修改环境变量

```yaml
environment:
  - NS_USER=your_username    # 修改默认用户名
  - NS_PWD=your_password     # 修改默认密码
  - JAVA_OPTS=-Xms2g -Xmx4g  # 调整内存分配
```

#### 数据持久化

数据默认存储在 Docker volume `northstar_data` 中。
如需指定主机路径：

```yaml
volumes:
  - /path/to/your/data:/northstar-dist/data
  - /path/to/your/logs:/northstar-dist/logs
```

## 访问服务

启动成功后，通过浏览器访问：

- **Web 监控台**：https://localhost (或自定义端口)
- **默认账号**：
  - 用户名：admin
  - 密码：123456

## 查看日志

```bash
# 实时查看日志
docker compose logs -f northstar

# 或查看日志文件
tail -f logs/northstar.log
```

## 更新服务

```bash
# 拉取最新镜像
./start.sh

# 或手动更新
docker compose pull northstar
docker compose up -d
```

## 故障排查

### 容器无法启动

```bash
# 查看容器状态
docker compose ps

# 查看详细错误
docker compose logs northstar

# 检查端口占用
netstat -tlnp | grep 443
netstat -tlnp | grep 51688
```

### 检查健康状态

```bash
# 查看容器健康状态
docker inspect northstar --format='{{.State.Health.Status}}'

# 手动健康检查
curl -f http://localhost:51688/actuator/health
```

### 清理数据（重置）

```bash
# 停止服务
./stop.sh

# 删除数据卷（会丢失所有数据！）
docker volume rm northstar_northstar_data

# 删除日志
rm -rf logs/

# 重新启动
./start.sh
```

## 性能调优

### JVM 参数调整

编辑 `docker-compose.yml` 中的 `JAVA_OPTS`：

```yaml
environment:
  - JAVA_OPTS=-Xms2g -Xmx4g -XX:+UseG1GC -XX:MaxGCPauseMillis=200
```

### 资源限制

```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 4G
    reservations:
      cpus: '1'
      memory: 2G
```

## 安全建议

⚠️ **生产环境部署时请务必**：

1. **修改默认密码**：编辑 `NS_USER` 和 `NS_PWD`
2. **使用 HTTPS**：配置 SSL 证书
3. **限制访问**：使用防火墙限制 IP 访问
4. **定期备份**：备份数据卷 `./data` 目录
5. **日志监控**：配置日志轮转和监控告警

## 版本标签

可以使用特定版本标签而非 latest：

```yaml
image: ghcr.io/fjiayang/northstar:v7.3.6
```

可用标签：
- `latest` - 最新版本
- `v7.3.6` - 具体版本
- `v7.3` - 次要版本

## 支持

如有问题，请查看：
- [项目文档](https://www.quantit.tech/)
- [GitHub Issues](https://github.com/FJiayang/northstar/issues)
