#!/bin/bash
# 
#Usage: TestDFSIO [genericOptions] -read [-random | -backward | -skip [-skipSize Size]] | -write | -append | -clean [-compression codecClassName] [-nrFiles N] [-size Size[B|KB|MB|GB|TB]] [-resFile resultFileName] [-bufferSize Bytes] [-rootDir]
# TestDFSIO
# The available options:
# -clean
# -read // read from hdfs
# -write // write to hdfs
# -nrFiles // generate count of file in HDFS
# -Size // File Size you want to read | write
# -resFile // default will append to TestDFSIO_results.log, or write to FILE you assigned
# display hdfs content
# hdfs dfs -ls /benchmarks/TestDFSIO/io_write/
# Found 2 items
# -rw-r--r--   1 hdadm supergroup          0 2014-04-23 17:05 /benchmarks/TestDFSIO/io_write/_SUCCESS
# -rw-r--r--   1 hdadm supergroup         77 2014-04-23 17:05 /benchmarks/TestDFSIO/io_write/part-00000
# hdadm@namenode:~$ 
# The result log

#
CMD=$(echo "hadoop jar /home/hdadm/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.3.0-tests.jar TestDFSIO")

# clean
#$CMD -clean

# generate 10 files with 1000MB
#$CMD -write -nrFiles 10 -fileSize 1000

# read generated file from -write
#$CMD -read -nrFiles 10 -fileSize 1000

test_files="1 8 32 64 128 512 1024 4096"
test_size_GB="1 8 32 64 128 256 512"
#test_size_TB="1024 8*1024 32*1024 64*1024 128*1024 512*1024"
limit_size_GB=$((640*1024))

for files in $test_files; do
	for size in $test_size_GB; do
		current_size=$(($files*$size))
		echo $current_size
		if [ $current_size -lt $limit_size_GB ]; then
			size+="GB"
			$CMD -clean
			$CMD -write -nrFiles $files -fileSize $size
			$CMD -read -nrFiles $files -fileSize $size
		fi
	done
done

