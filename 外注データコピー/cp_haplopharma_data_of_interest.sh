#!/bin/bash

USER_REMOTE=user@gw.ddbj.nig.ac.jp
HDD_DIR=XXX/
SEQ_ID=XXX/
DEST_DIR0=/home/user/fastq_batch_1/


mkdir_and_scp() {
  USER_REMOTE=$1
  DEST_DIR=$2
  SOURCES=("${@:3}") 

  DEST="${USER_REMOTE}:${DEST_DIR}"
  ssh ${USER_REMOTE} "mkdir -p ${DEST_DIR}"
  for SOURCE in "${SOURCES[@]}"; do
    scp -r "${SOURCE}" "${DEST}"
  done
}


# ステップ０−１：ファイル・ディレクトリサイズを見てコピーするものを選ぶ
du -sh /Volumes/${HDD_DIR}/${SEQ_ID}/*
du -sh /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/*      
du -sh /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/*
du -sh /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/*
du -sh /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/*
du -sh /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/*               


# ステップ０−２：まずパスワード入力を一時的に省略する
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa


# ステップ１：
# - コピー先ディレクトリを作る
# - コピーしたいファイル・ディレクトリを選んでコピーする
DEST_DIR="${DEST_DIR0}"
mkdir_and_scp ${USER_REMOTE} ${DEST_DIR} \
  /Volumes/${HDD_DIR}/フローセル占有シーケンス解析\ 作業報告書.pdf \
  /Volumes/${HDD_DIR}/カスタムプロット結果のご報告.pdf


DEST_DIR="${DEST_DIR0}${SEQ_ID}"
mkdir_and_scp "${USER_REMOTE}" "${DEST_DIR}" \
  /Volumes/${HDD_DIR}/${SEQ_ID}/CopyComplete.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/InstrumentAnalyticsLogs \
  /Volumes/${HDD_DIR}/${SEQ_ID}/InterOp \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Logs \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Manifest.tsv \
  /Volumes/${HDD_DIR}/${SEQ_ID}/RTA.cfg \
  /Volumes/${HDD_DIR}/${SEQ_ID}/RTAComplete.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/RTAExited.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/RunCompletionStatus.xml \
  /Volumes/${HDD_DIR}/${SEQ_ID}/RunInfo.xml \
  /Volumes/${HDD_DIR}/${SEQ_ID}/RunParameters.xml \
  /Volumes/${HDD_DIR}/${SEQ_ID}/SampleSheet.csv \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Thumbnail_Images \
  /Volumes/${HDD_DIR}/${SEQ_ID}/check.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/md5_cbcl.txt


DEST_DIR=${DEST_DIR0}${SEQ_ID}Analysis/1/
mkdir_and_scp "${USER_REMOTE}" "${DEST_DIR}" \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/CopyComplete.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Manifest.tsv 


DEST_DIR=${DEST_DIR0}${SEQ_ID}/Analysis/1/Data/
mkdir_and_scp "${USER_REMOTE}" "${DEST_DIR}" \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/AggregateReports \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/Demux \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/RunInstrumentAnalyticsMetrics \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/Secondary_Analysis_Complete.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/b2c_dragen_events.csv \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/dmx_dragen_events.csv \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/logs \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/summary


DEST_DIR=${DEST_DIR0}${SEQ_ID}/Analysis/1/Data/BCLConvert/
mkdir_and_scp "${USER_REMOTE}" "${DEST_DIR}" \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/AggregateReports \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/SampleSheet.csv \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/logs


DEST_DIR=${DEST_DIR0}${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/
mkdir_and_scp "${USER_REMOTE}" "${DEST_DIR}" \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/Logs \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/Reports \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/check.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen-replay.json \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen.time_metrics.csv \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen_run_*.log \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/md5_fastq.txt \
  /Volumes/${HDD_DIR}/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/streaming_log_fcmuser.csv
