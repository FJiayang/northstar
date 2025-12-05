# 使用 Eclipse Temurin OpenJDK 21
FROM eclipse-temurin:21-jre

# 创建工作目录
RUN mkdir -p /northstar-dist
WORKDIR /northstar-dist

# 复制northstar-dist目录下的所有文件到工作目录
COPY northstar-dist/ ./

ENV NS_USER=admin
ENV NS_PWD=123456
ENV TZ=Asia/Shanghai

# 添加启动脚本
RUN echo 'java -Denv=prod -Dloader.path=/northstar-dist -jar /northstar-dist/northstar-*.jar' > /northstar-dist/entrypoint.sh

EXPOSE 443
EXPOSE 51688

# 运行启动脚本
CMD ["bash","/northstar-dist/entrypoint.sh"]