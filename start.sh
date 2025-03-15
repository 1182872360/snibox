#!/bin/bash

# 确保在正确的目录
cd /app

# 删除旧的 pid 文件
rm -f tmp/pids/server.pid

# 启动 Rails 服务器
sh -c "SECRET_KEY_BASE=$(openssl rand -hex 64) bundle exec puma -C config/puma.rb" &

# 等待 Rails 服务器启动
while ! nc -z localhost 3000; do
  sleep 1
done

# 启动 Nginx
exec nginx -g 'daemon off;'