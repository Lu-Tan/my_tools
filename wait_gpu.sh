#!/bin/bash

# 获取每张GPU显存大小
gpu_info=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
gpu_mem=($gpu_info)

# 输出每张GPU的显存大小
for i in "${!gpu_mem[@]}"; do
  echo "GPU $i: ${gpu_mem[$i]}"
done

# 设置剩余可用显存的最小值
min_mem=5000  # 单位为M

# 循环检查每张GPU剩余可用显存
for i in "${!gpu_mem[@]}"; do
  # 获取当前GPU已用显存大小
  used_info=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i $i)
  used_mem=($used_info)

  # 计算当前GPU剩余可用显存大小
  free_mem=$(expr ${gpu_mem[$i]} - ${used_mem[$i]})

  # 检查剩余可用显存是否大于最小值，如果是就在当前GPU上启动main.py
  if [ $free_mem -gt $min_mem ]; then
    echo "GPU $i has enough memory (${free_mem}M). Running main.py on GPU $i..."
    CUDA_VISIBLE_DEVICES=$i python main.py
    break
  else
    echo "GPU $i does not have enough memory (${free_mem}M)."
  fi
done
