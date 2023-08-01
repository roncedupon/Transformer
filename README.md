# 每个分支是干啥的？
master 分支暂时没啥用。
一共有三条开发路线，分别是：transformer 量化（Quan），transformer硬件实现（Spinal），matlab测试数据生成（Matlab）
目前卢浩的代码也集成进来了，Spinal_Main部分的代码都是已经仿真和上板验证过的

# Quan量化部分
## Quan_Main 稳定的量化主分支
## Quan_V6 可以用FQ-Vit做训练，训练完后再用FQ-Vit量化（最新分支)
## Quan_V5 用来测试Softmax
## Quan_V4 用来测试layernorm
## Quan_JQ 用来在集群上测试
## 其他的Quan，没啥用

# Spianl部分（只需要关注Spinal_Main分支）
## Spinal_V1 写layernorm的（已经失效）
## Spinal_V2 写计算模块的第一个缓存模块，img2col（已经失效）
## Spinal_V3 用来写计算模块的第二个缓存模块:Weight_Cache,权重缓存(最新分支)
## Spinal_Main 是稳定的分支，目前好像实现了8*8阵列的卷积+矩阵+卷积+矩阵量化

# Matlab部分
## Matlab分支包含matlab生成仿真测试txt，还有c++的gold ref