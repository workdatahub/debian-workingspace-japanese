# workdatahub/debian-workingspace-japanese

## cliターミナルにログインして使う為にDebianを日本語化した作業空間

 本体PCの環境を汚さずにDebian環境を再現して、docker内の仮想空間で作業する為の使い捨てのワークスペース。

下記コマンドで起動するとdockerというユーザーで起動します。passはdockerです。  

```shell
docker run -it workdatahub/debian-workingspace-japanese /bin/bash

※ apt を利用するには最初に sudo apt update が必要。
`

- 日本語表示にしています。
- 次に記述するパッケージをインストール。
  apt-utils , sudo , locales , vim , git , curl , wget , ssh , ca-certificates
- ディレクトリに色付け。
- vimにmolokaiで色付けして一部色変更。
- vimのマウス動作を挿入モード時のみに変更。
- ユーザー {docker}を追加。 passは{docker}

