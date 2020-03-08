# Dockerイメージを指定
FROM ruby:2.4.9

# インストール可能なパッケージ一覧を更新　&　必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    # ビルドツール
    build-essential \
    # npmを使うため
    nodejs \
    # キャッシュを削除してイメージの容量削減
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# bundlerをインストール
RUN gem install bundler -v 1.17.3

# 作業ディレクトリを作成、環境変数に割当
RUN mkdir /app_root
ENV APP_ROOT /app_root 
WORKDIR $APP_ROOT

# カレントディレクトリをコンテナにコピー
COPY . $APP_ROOT/

# bundle install & 高速化するための設定
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    bundle install && \
    rm -rf ~/.gem
