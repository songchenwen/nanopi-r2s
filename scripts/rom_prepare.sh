#!/bin/bash

sScriptName="$(basename $0)"

if [ $(pidof ${sScriptName}| wc -w) -gt 2 ]; then
    pids=$(pidof ${sScriptName})
    echo "其他任务正在执行刷机 ${pids}"
    exit 1
fi

needed_binaries=(unzip gunzip pv losetup tar zstdmt zstdcat)

need_warn=""
for i in "${needed_binaries[@]}"; do
    w_b=$(which $i)
    if [ "$w_b" == "" ]; then
        need_warn="${need_warn} $i"
    fi
done
if ! [ "$need_warn" == "" ]; then
    echo "无法刷机, 需要这些可执行文件 $need_warn"
    exit 1
fi

workingdir=/root/r2sflasher/

rm -rf $workingdir
mkdir -p $workingdir

cd $workingdir

inputfile=$1
nobackup=$2
lomntpoint=/mnt/img
backupfile=$workingdir/backup.tar.gz

if [ "$inputfile" == "" ];then
   echo "需要传入 ROM zip 文件"
   exit 1
fi

if [ -f "$inputfile" ]; then
    echo "固件上传成功"
else
    echo "固件上传失败"
    cd /root
    rm -rf $workingdir
    exit 1
fi

inputfileext=${inputfile##*.}

gzfile=""

if [ "$inputfileext" == "gz" ]; then
    gzfile="$inputfile"
fi

if [ "$inputfileext" == "zip" ]; then
    gzfile=$(unzip -Z -1 "$inputfile" | grep "sd.img.gz$")
    imgfile=$(unzip -Z -1 "$inputfile" | grep ".img$")

    if [ "$gzfile" == "" ] && [ "$imgfile" == "" ]; then
        echo "没发现 sd.img.gz 结尾的固件包"
        cd /root
        rm -rf $workingdir
        exit 1
    fi
    
    if ! [ "$gzfile" == "" ]; then
        unzip "$inputfile" "$gzfile"
        imgfile=""
    else
        if ! [ "$imgfile" == "" ]; then
            unzip "$inputfile" "$imgfile"
        fi 
    fi
    
    rm $inputfile

    if [ -f "$gzfile" ] || [ -f "$imgfile" ]; then
        echo "zip 固件已解压至 ${gzfile}${imgfile}"
    else
        echo "zip 固件解压失败"
        cd /root
        rm -rf $workingdir
        exit 1
    fi
fi

if [ "$gzfile" == "" ] && [ "$imgfile" == "" ]; then
    echo "不是有效的 ROM 文件"
    cd /root
    rm $inputfile
    rm -rf $workingdir
    exit 1
fi

if ! [ "$gzfile" == "" ]; then
    echo "开始解压 gz 文件......"
    imgfile="rom.img"
    pv -f -F "%e %p" -i 1 "$gzfile" | gunzip -dc > "$imgfile"
    if [ -f "$imgfile" ]; then
        echo "gz 固件已解压至 $imgfile"
        rm $gzfile
    else
        echo "gz 固件解压失败"
        rm $gzfile
        cd /root
        rm -rf $workingdir
        exit 1
    fi
fi

lodev=$(losetup -f)
echo "使用设备 $lodev 测试 ROM 文件"

mkdir -p "$lomntpoint"
losetup -o 100663296 $lodev "$imgfile"
mount $lodev "$lomntpoint"
if [ $? -ne 0 ]; then
    echo "img 文件挂载失败"
    losetup -d $lodev
    cd /root
    rm -rf $workingdir
    exit 1
fi

cd "$lomntpoint"
imgbindir=$(ls | grep "bin")
if [ "$imgbindir" == "" ]; then
    echo "img 文件错误"
    cd /root
    umount "$lomntpoint"
    losetup -d $lodev
    rm -rf $workingdir
    exit 1
fi

if [ "$2" == "nobackup" ]; then
    echo "不备份设置"
else 
    echo "开始备份设置"
    rm -f "$backupfile"
    sysupgrade -b "$backupfile"
    if ! [ -f "$backupfile" ]; then
        echo "生成备份文件失败"
        cd /root
        umount "$lomntpoint"
        losetup -d $lodev
        rm -rf $workingdir
        exit 1
    fi
    echo "开始写入备份到镜像文件"
    tar zxf "$backupfile"
    echo "备份文件已写入, 移除挂载"
    rm "$backupfile"
fi

cd /tmp
umount "$lomntpoint"
losetup -d $lodev

finalfile="/root/$imgfile.gz"
echo "开始压缩镜像至 $finalfile"
rm -f $finalfile
gzip "${workingdir}${imgfile}"
mv "${workingdir}${imgfile}.gz" "$finalfile"
rm -rf $workingdir

if [ -f "$finalfile" ]; then
    echo "ROM 已准备好 $finalfile"
else
    echo "压缩出错"
    exit 1
fi
