#!/usr/bin/env python3


import requests
import pandas as pd


def download_from_URLs( urls ):
  # ダウンロードしたいファイルのURLをリストで与える
  for url in urls:
    filename = url.split("/")[-1] # ファイル名をURLから抽出
    response = requests.get(url)
    response.raise_for_status()   # エラーがあれば例外を投げる
    with open(filename, "wb") as f:
      f.write(response.content)


def extract_filenames_from_urls( urls ):
  filenames = []
  for url in urls:
    filename = url.strip().split('/')[-1]
    filenames.append( filename )
  
  return filenames


def make_concatenated_df( files, **read_kwargs ):
  dfs = []
  for file in files:
    df = pd.read_csv( file, **read_kwargs )
    df['__source__'] = file  # 元ファイル名を記録
    dfs.append( df )
  
  concatenated_df = pd.concat( dfs, ignore_index=True )
  return concatenated_df

