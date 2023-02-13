# 每个分支是干啥的？
master 分支暂时没啥用。
一共有三条开发路线，分别是：transformer 量化（Quan），transformer硬件实现（Spinal），matlab测试数据生成（Matlab）
# Quan量化部分
## Quan_V5 用来测试Softmax
## Quan_V4 用来测是layernorm
## Quan_JQ 用来在集群上测试
## 其他的Quan，没啥用

# Spianl部分
## Spinal_V1 写layernorm的
## Spinal_V2 写计算模块的第一个缓存模块，img2col
## Spinal_V3 用来写计算模块的第二个缓存模块:Weight_Cache,权重缓存


# Matlab部分
## Matlab分支包含matlab生成仿真测试txt，还有c++的gold ref