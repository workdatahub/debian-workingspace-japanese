FROM debian AS debian-work1
ARG USER_ID=docker

# リポジトリ設定
RUN /bin/rm /etc/apt/sources.list
RUN echo "deb http://ftp.jp.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list
RUN echo "deb-src http://ftp.jp.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list

# 必要なパッケージをインストール
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    apt-utils \
    wget \
    ssh \
    ca-certificates

# ルート証明書のダウンロード
RUN mkdir /usr/local/share/ca-certificates/cacert.org
RUN wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt
RUN update-ca-certificates
# molkai ダウンロード
RUN wget -P /usr/share/vim/vim81/colors/ --no-check-certificate https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim

# ユーザー追加
RUN useradd -m ${USER_ID}

# 色等設定
COPY .bashrc /root/.bashrc
COPY .dircolors /root/.dircolors
COPY .bashrc /home/${USER_ID}/.bashrc
COPY .dircolors /home/${USER_ID}/.dircolors
COPY defaults.vim /usr/share/vim/vim81/defaults.vim
WORKDIR /usr/share/vim/vim81/colors/
RUN sed -i -e "223c \ \ \ hi Visual                      ctermbg=236" molokai.vim
RUN sed -i -e "227c \ \ \ hi Comment         ctermfg=102" molokai.vim
RUN sed -i -e "267c \ \ \ \ \ \ \ hi Comment         ctermfg=102" molokai.vim
COPY vimrc /etc/vim/vimrc

# ----  必要なものだけ取り出す ----
FROM scratch AS debian-work2
ARG USER_ID=docker

COPY --from=debian-work1 /etc/apt/sources.list /etc/apt/sources.list
COPY --from=debian-work1 /usr/local/share/ca-certificates/cacert.org/ /usr/local/share/ca-certificates/cacert.org/
COPY --from=debian-work1 /usr/share/vim/vim81/colors/molokai.vim /usr/share/vim/vim81/colors/molokai.vim
COPY --from=debian-work1 /usr/share/vim/vim81/defaults.vim /usr/share/vim/vim81/defaults.vim
COPY --from=debian-work1 /root/.bashrc /root/.bashrc
COPY --from=debian-work1 /root/.dircolors /root/.dircolors
COPY --from=debian-work1 /home/${USER_ID}/.bashrc /home/${USER_ID}/.bashrc
COPY --from=debian-work1 /home/${USER_ID}/.dircolors /home/${USER_ID}/.dircolors
COPY --from=debian-work1 /etc/vim/vimrc /etc/vim/vimrc

# ----- 本体 -----
FROM  debian
ARG USER_ID=docker
ARG PASSWD=docker

# 必要なパッケージをインストール
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    apt-utils \
    sudo \
    locales \
    vim \
    git \
    curl \
    wget \
    ssh \
    ca-certificates \
# ユーザー追加
    && useradd -m ${USER_ID} \
    && echo "${USER_ID}:${PASSWD}" | chpasswd \
    && echo "${USER_ID} ALL=(ALL) ALL" >> /etc/sudoers \
    && usermod -aG adm,cdrom,sudo,ssh,audio,video,plugdev,games,users ${USER_ID} \
# ロケール変更
    && locale-gen ja_JP.UTF-8 \
    && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
    && cp -p /usr/share/zoneinfo/Japan /etc/localtime \
# クリーニング
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

# 環境設定
ENV LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8 \
    LC_CTYPE=ja_JP.UTF-8 \
    HOME=/home/${USER_ID} \
    TERM=xterm

# 設定ファイルを導入
COPY --from=debian-work2 / /

# ユーザーファイルの所有者変更
RUN chown -R ${USER_ID}:${USER_ID} /home/${USER_ID}/

# ユーザーでログイン
WORKDIR /home/${USER_ID}
USER ${USER_ID}
SHELL ["/bin/bash", "-c"]
