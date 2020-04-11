#!/bin/bash

cd /root

url=$1
zipfile=update_rom.zip
imgfile=rom.img
lomntpoint=/mnt/img
backupfile=/tmp/backup.tar.gz

if [ "$url" == "" ];then
   echo "需要传入 ROM zip 文件下载链接"
   exit 1
fi

rm -f "$zipfile"
rm -f "$imgfile"
rm -f "$backupfile"
rm -f "/tmp/$imgfile.zst"
rm -f *sd.img.gz

echo "开始下载固件文件 $url"
wget -O "$zipfile" "$url"

if [ -f "$zipfile" ]; then
    echo "固件下载成功"
else
    echo "固件下载失败"
    exit 1
fi

gzfile=$(unzip -Z -1 "$zipfile" | grep "sd.img.gz$")

if [ "$gzfile" == "" ]; then
    echo "没发现 sd.img.gz 结尾的固件包"
    exit 1
fi
unzip "$zipfile" "$gzfile"
rm $zipfile

if [ -f "$gzfile" ]; then
    echo "zip 固件已解压至 $gzfile"
else
    echo "zip 固件解压失败"
    exit 1
fi

pv "$gzfile" | gunzip -dc > "$imgfile"
if [ -f "$imgfile" ]; then
    echo "gz 固件已解压至 $imgfile"
else
    echo "gz 固件解压失败"
    exit 1
fi

lodev=$(losetup -f)
echo "使用设备 $lodev 改写 ROM 文件"

mkdir -p "$lomntpoint"
losetup -o 100663296 $lodev "$imgfile"
mount $lodev "$lomntpoint"
cd "$lomntpoint"
echo "开始备份设置"
sysupgrade -b "$backupfile"
echo "开始写入备份到镜像文件"
tar zxf "$backupfile"
echo "备份文件已写入, 移除挂载"

cd /tmp
rm "$backupfile"
umount "$lomntpoint"
losetup -d $lodev

echo "开始压缩镜像"
zstfile="/tmp/$imgfile.zst"
zstdmt "/root/$imgfile" -o "$zstfile"

if [ -f "$zstfile" ]; then
    echo 1 > /proc/sys/kernel/sysrq
    echo "卸载 SD 卡"
    echo u > /proc/sysrq-trigger || umount /

    rotestfile="/rotest.txt"
    touch "$rotestfile"
    if [ $? -eq 0 ]; then
        rm "$rotestfile"
        echo "卸载 SD 卡失败"
        exit 1
    fi

    echo "开始刷机, 请不要断电或关机, 如果刷机失败请取出 SD 卡用电脑重新写入 ROM"
    pv "$zstfile" | zstdcat | dd of=/dev/mmcblk0 conv=fsync
    echo "刷机完毕, 正在重启..."
    echo o > /proc/sysrq-trigger
else
    echo "压缩出错"
    exit 1
fi
