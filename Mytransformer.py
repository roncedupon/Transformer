#实现第一个embed层
from turtle import forward
import torch
import torch.nn as nn
class Simple_Transformer(nn.Module):
    def __init__(self, img_size=224, patch_size=16, Picture_IN_Channel=3, embed_dim=768, norm_layer=None):
        super().__init__()
        #初始化层，构建token与插入位置编码还有class token
        img_size = (img_size, img_size)#图片大小
        patch_size = (patch_size, patch_size)#patch形状为正方形
        self.img_size = img_size
        self.patch_size = patch_size
        self.grid_size = (torch.div(img_size[0],patch_size[0],rounding_mode='floor'), torch.div(img_size[1],patch_size[1],rounding_mode='floor')) #每行和每列的oatch数量使用向下取整
        self.num_patches = self.grid_size[0] * self.grid_size[1]#patch数量
        #构建卷积层==================================================================================
        self.ConvLayer = nn.Conv2d(Picture_IN_Channel , embed_dim, kernel_size=patch_size, stride=patch_size)#输入通道，输出通道，卷积核大小，步长
        self.norm = norm_layer(embed_dim) if norm_layer else nn.Identity()
        #构建drop out层==============================================================================
        
        #构建class token================================================================================
        
        self.cls_token = nn.Parameter(torch.zeros(1, 1, embed_dim))#新建一个class token
        #构建位置编码
        self.pos_embed = nn.Parameter(torch.zeros(1, self.num_patches + 1, embed_dim))

    def Init_Layer(self, x):
        B, C, H, W = x.shape
        assert H == self.img_size[0] and W == self.img_size[1], \
            f"Input image size ({H}*{W}) doesn't match model ({self.img_size[0]}*{self.img_size[1]})."
        # flatten: [B, C, H, W] -> [B, C, HW]
        # transpose: [B, C, HW] -> [B, HW, C]
        x = self.ConvLayer(x).flatten(2).transpose(1, 2)#行展开再转置,
        x = self.norm(x)

        #插入位置编码和class token
        cls_token = self.cls_token.expand(x.shape[0], -1, -1)#第一个维度为x.shape[0]--也就是x的batchsize,剩下的两个维度自动匹配
        x = torch.cat((cls_token, x), dim=1)  # [B, 197, 768]行数加一
        x = x+self.pos_embed
        return x
#构建注意力机制
class Attention(nn.Module):
    def __init__(self, Row=197,Col=768,Head_Num=12):
        super().__init__()
        self.Dim_Pre_Head=torch.div(Col,Head_Num,rounding_mode='floor')#都要在troch下跑
        #创建Q，K，V的linear
    # 每个头的维度（均分）⭐目前要求能整除
    


    def forward(self,x):
        print("Dim_Pre_Head is",self.Dim_Pre_Head)
        return self.V_Linears[0](x)


#用来测试的
Test_Attention_Input=torch.randn(1,1,197,64)
V_Linears=Attention()
Test_Attention=V_Linears(Test_Attention_Input)
print(Test_Attention)
exit()
Test_Picture=torch.randn(1,3,224,224)#tensor的数据格式：BCHW
Patch=Simple_Transformer(img_size=224, patch_size=16, Picture_IN_Channel=3, embed_dim=768, norm_layer=None)
Embed_Out=Patch.Init_Layer(Test_Picture)
print(Embed_Out.shape)


