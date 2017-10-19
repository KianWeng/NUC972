#!/bin/bash -

## layout
# 128 Bytes FAKE header
# plus OS.tar.gz

BIN=OS.bin
TAR=OS.tar.gz

rm -rf ${BIN}

tar --exclude=generate_bin.sh --exclude=970image --exclude=970image.zip -zcvf ${TAR} * &&
{
for out_pos in $(seq 0 2 62); do
        dd if=/dev/urandom of=${BIN} bs=1 count=1 seek=${out_pos} > /dev/null 2>&1
        dd if=/dev/zero of=${BIN} bs=1 count=1 seek=$((out_pos + 1)) > /dev/null 2>&1
done
} &&

dd if=${TAR} of=${BIN} bs=128 seek=1 > /dev/null 2>&1 &&
md5sum ${BIN} > ${BIN}.md5sum &&
{
for in_pos in $(seq 0 31); do
        dd if=${BIN}.md5sum of=${BIN} bs=1 count=1 seek=$((in_pos * 2 + 1)) skip=${in_pos} conv=notrunc > /dev/null 2>&1
done
} &&

rm -rf ${TAR} ${BIN}.md5sum &&

echo -e "\033[1m\033[7m\033[32m${BIN} is ready!\033[0m" ||
echo -e "\033[1m\033[7m\033[32m${BIN} failed!\033[0m"

