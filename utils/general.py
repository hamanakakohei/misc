#!/usr/bin/env python3


import requests


def download_from_URLs( urls ):
  # ダウンロードしたいファイルのURLをリストで与える
  for url in urls:
    filename = url.split("/")[-1] # ファイル名をURLから抽出
    response = requests.get(url)
    response.raise_for_status()   # エラーがあれば例外を投げる
    with open(filename, "wb") as f:
      f.write(response.content)

