#!/bin/bash

# ステップ０：まずパスワード入力を一時的に省略する
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa


# ステップ１：
# - ファイル・ディレクトリサイズを確認する
# - コピー先ディレクトリを作る
# - コピーしたいファイル・ディレクトリを選んでコピーする
USER_REMOTE=user@remote
SEQ_ID=XXX
DEST_DIR=/home/user/fastq_batch_1/
DEST=${USER_REMOTE}:${DEST_DIR}
ssh ${USER_REMOTE} 'mkdir -p ${DEST}'
scp -r /Volumes/Padlock_DT/フローセル占有シーケンス解析\ 作業報告書.pdf ${DEST}
scp -r /Volumes/Padlock_DT/カスタムプロット結果のご報告.pdf ${DEST}


du -sh /Volumes/Padlock_DT/${DATA_DIR}/*
#4.1T	/Volumes/Padlock_DT/${SEQ_ID}/Analysis
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/CopyComplete.txt
#2.8T	/Volumes/Padlock_DT/${SEQ_ID}/Data # 重いしいらない
# 20M	/Volumes/Padlock_DT/${SEQ_ID}/InstrumentAnalyticsLogs
#8.4G	/Volumes/Padlock_DT/${SEQ_ID}/InterOp
#6.7G	/Volumes/Padlock_DT/${SEQ_ID}/Logs
#4.1M	/Volumes/Padlock_DT/${SEQ_ID}/Manifest.tsv
#4.0K	/Volumes/Padlock_DT/${SEQ_ID}/RTA.cfg
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/RTAComplete.txt
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/RTAExited.txt
#4.0K	/Volumes/Padlock_DT/${SEQ_ID}/RunCompletionStatus.xml
#156K	/Volumes/Padlock_DT/${SEQ_ID}/RunInfo.xml
#4.0K	/Volumes/Padlock_DT/${SEQ_ID}/RunParameters.xml
# 40K	/Volumes/Padlock_DT/${SEQ_ID}/SampleSheet.csv
#5.0G	/Volumes/Padlock_DT/${SEQ_ID}/Thumbnail_Images
#596K	/Volumes/Padlock_DT/${SEQ_ID}/check.txt
#932K	/Volumes/Padlock_DT/${SEQ_ID}/md5_cbcl.txt
DEST=${USER_REMOTE}:${DEST_DIR}${SEQ_ID}/
ssh ${USER_REMOTE} 'mkdir -p ${DEST}'
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/CopyComplete.txt ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/InstrumentAnalyticsLogs ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/InterOp ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/Logs ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/Manifest.tsv ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/RTA.cfg ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/RTAComplete.txt ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/RTAExited.txt ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/RunCompletionStatus.xml ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/RunInfo.xml ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/RunParameters.xml ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/SampleSheet.csv ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/Thumbnail_Images ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/check.txt ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/md5_cbcl.txt ${DEST}


du -sh /Volumes/Padlock_DT/${DATA_DIR}/Analysis/*      
#4.1T	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1


du -sh /Volumes/Padlock_DT/${DATA_DIR}/Analysis/1/*
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/CopyComplete.txt
#4.1T	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data
#160K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Manifest.tsv
DEST=${USER_REMOTE}:${DEST_DIR}${SEQ_ID}/Analysis/1/
ssh ${USER_REMOTE} 'mkdir -p ${DEST}'
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/CopyComplete.txt ${DEST}
scp -r	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Manifest.tsv ${DEST}


du -sh /Volumes/Padlock_DT/${DATA_DIR}/Analysis/1/Data/*
#172M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/AggregateReports
#4.1T	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert
# 54M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/Demux
# 28M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/RunInstrumentAnalyticsMetrics
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/Secondary_Analysis_Complete.txt
# 24K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/b2c_dragen_events.csv
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/dmx_dragen_events.csv
#5.6M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/logs
# 24K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/summary
DEST=${USER_REMOTE}:${DEST_DIR}${SEQ_ID}/Analysis/1/Data/
ssh ${USER_REMOTE} 'mkdir -p ${DEST}'
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/AggregateReports ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/Demux ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/RunInstrumentAnalyticsMetrics ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/Secondary_Analysis_Complete.txt ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/b2c_dragen_events.csv ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/dmx_dragen_events.csv ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/logs ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/summary ${DEST}


du -sh /Volumes/Padlock_DT/${DATA_DIR}/Analysis/1/Data/BCLConvert/*
#2.8M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX
#2.8M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX
#2.8M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX
#167M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/AggregateReports
# 40K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/SampleSheet.csv
#4.1T	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq
#9.5M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/logs
DEST=${USER_REMOTE}:${DEST_DIR}${SEQ_ID}/Analysis/1/Data/BCLConvert/
ssh ${USER_REMOTE} 'mkdir -p ${DEST}'
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/XXX ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/AggregateReports ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/SampleSheet.csv ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/logs ${DEST}


du -sh /Volumes/Padlock_DT/${DATA_DIR}/Analysis/1/Data/BCLConvert/fastq/*               
#8.0K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/Logs
#147M	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/Reports
#6.7G	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX
#6.6G	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX
#6.8G	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX
# 56K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/check.txt
# 52K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen-replay.json
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen.time_metrics.csv
# 12K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen_run_1740637391208_254085.log
# 88K	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/md5_fastq.txt
#  0B	/Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/streaming_log_fcmuser.csv
DEST=${USER_REMOTE}:${DEST_DIR}${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/
ssh ${USER_REMOTE} 'mkdir -p ${DEST}'
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/Logs ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/Reports ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/XXX ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/check.txt ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen-replay.json ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen.time_metrics.csv ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/dragen_run_1740637391208_254085.log ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/md5_fastq.txt ${DEST}
scp -r  /Volumes/Padlock_DT/${SEQ_ID}/Analysis/1/Data/BCLConvert/fastq/streaming_log_fcmuser.csv ${DEST}

