#!/usr/bin/env python3

import argparse
from pypdf import PdfReader, PdfWriter


def extract_first_page(input_pdf, output_pdf):
    # PDFの読み込み
    reader = PdfReader(input_pdf)

    # 新しいPDFライターを作成
    writer = PdfWriter()

    # 1ページ目を追加
    writer.add_page(reader.pages[0])

    # 抽出したページを保存
    with open(output_pdf, "wb") as output_file:
        writer.write(output_file)

    print(f"1ページ目を {output_pdf} に保存しました！")


def main():
    # 引数の設定
    parser = argparse.ArgumentParser(description="PDFの1ページ目を抽出して保存します。")
    parser.add_argument("input", help="入力PDFファイルのパス")
    parser.add_argument("output", help="出力PDFファイルのパス")
    args = parser.parse_args()

    # 関数を実行
    extract_first_page(args.input, args.output)


if __name__ == "__main__":
    main()

