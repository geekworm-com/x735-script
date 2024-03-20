#!/bin/bash

# 由于ubuntu自从23.04版本的内核升级到6.2, 该内核不支持sysfs的方式来读写GPIO,所以我们用了官方推荐的libgpiod库来开发了对应的程序
# xgpio_pwr 负责电源管理，等效于x-c1-pwr.sh， xgpio_soft 负责软件关机，等效于x-c1-soft.sh；
# 要注意的这两个程序支持参数的传入，具体可参考源代码；
# 可以参考 https://github.com/geekworm-com/xgpio 来了解xgpio_pwr和xgpio_soft
# 我们需要在ubuntu环境中编译一下这个程序，也可以直接使用我们编译好的程序；

file_path="xgpio_pwr"
if [ -f "$file_path" ]; then
    sudo rm -f "$file_path"
fi

file_path="xgpio_soft"
if [ -f "$file_path" ]; then
    sudo rm -f "$file_path"
fi

# 下载可执行文件
wget https://github.com/geekworm-com/xgpio/raw/main/bin/ubuntu/xgpio_pwr  /bin/ubuntu/xgpio_pwr

wget https://github.com/geekworm-com/xgpio/raw/main/bin/ubuntu/xgpio_soft /bin/ubuntu/xgpio_soft


# 设置+x属性
file_path="xgpio_pwr"
if [ -f "$file_path" ]; then
    chmod +x "$file_path"
fi

file_path="xgpio_soft"
if [ -f "$file_path" ]; then
    chmod +x "$file_path"
fi
