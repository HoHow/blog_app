# MySQL 資料庫設定說明

## 本地開發環境設定

### 1. 安裝 MySQL

#### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install mysql-server mysql-client libmysqlclient-dev
```

#### macOS:
```bash
brew install mysql
brew services start mysql
```

#### Windows:
下載並安裝 MySQL Community Server

### 2. 設定 MySQL

```bash
# 啟動 MySQL 服務
sudo systemctl start mysql

# 設定 root 密碼
sudo mysql_secure_installation

# 登入 MySQL
mysql -u root -p

# 建立資料庫使用者（可選）
CREATE USER 'blogs_app'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON blogs_app_development.* TO 'blogs_app'@'localhost';
GRANT ALL PRIVILEGES ON blogs_app_test.* TO 'blogs_app'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3. 安裝 Ruby gems

```bash
# 安裝 gems
bundle install

# 建立資料庫
rails db:create

# 執行遷移
rails db:migrate

# 載入種子資料（可選）
rails db:seed
```

### 4. 啟動應用程式

```bash
rails server
```

## Docker 環境設定

### 使用 Docker Compose

```bash
# 建立並啟動容器
docker-compose up --build

# 在背景執行
docker-compose up -d

# 查看日誌
docker-compose logs -f

# 停止容器
docker-compose down
```

### 手動建立 Docker 容器

```bash
# 建立 MySQL 容器
docker run --name mysql-blogs-app \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=blogs_app_development \
  -p 3306:3306 \
  -d mysql:8.0

# 建立 Rails 應用程式容器
docker build -t blogs-app .
docker run -p 3000:3000 \
  -e DATABASE_HOST=host.docker.internal \
  -e DATABASE_USERNAME=root \
  -e DATABASE_PASSWORD=password \
  blogs-app
```

## 資料庫配置

### 開發環境
- 主機: localhost
- 端口: 3306
- 使用者: root
- 密碼: password
- 資料庫: blogs_app_development

### 測試環境
- 主機: localhost
- 端口: 3306
- 使用者: root
- 密碼: password
- 資料庫: blogs_app_test

### 生產環境
使用環境變數設定：
- DATABASE_HOST
- DATABASE_USERNAME
- DATABASE_PASSWORD

## 常見問題

### 1. 連線被拒絕
確保 MySQL 服務正在運行：
```bash
sudo systemctl status mysql
```

### 2. 認證錯誤
檢查使用者名稱和密碼是否正確。

### 3. 權限錯誤
確保使用者有適當的資料庫權限。

### 4. 字符編碼問題
MySQL 配置使用 utf8mb4 編碼，支援完整的 Unicode 字符。
