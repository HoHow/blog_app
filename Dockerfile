FROM ruby:3.2.2

# 安裝系統依賴
RUN apt-get update -qq && apt-get install -y nodejs mysql-client

# 設定工作目錄
WORKDIR /app

# 複製 Gemfile
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# 安裝 gems
RUN bundle install

# 複製應用程式程式碼
COPY . /app

# 添加執行權限
RUN chmod +x /app/bin/rails

# 暴露端口
EXPOSE 3000

# 啟動命令
CMD ["rails", "server", "-b", "0.0.0.0"]
