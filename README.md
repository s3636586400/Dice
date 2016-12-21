# Dice
![image](https://github.com/s3636586400/Dice/blob/master/ImageSource/A941C98E-0579-4149-A0CE-A414D2E4507C.png)
筛子绘图的Objective-C实现。  
原文传送门：http://www.ruanyifeng.com/blog/2011/11/dice_portrait.html
# How To Use
`MIDicePhotoMaker` class:
```
- (void)makeDiceImageFromImageView:(UIImageView *)imageView;
```
图片生成后由代理回传：
```
- (void)receiveDicePhotoImage:(UIImage *)image;
```
# Problem
模拟器上执行耗时十多秒，真机更长，大部分时间用在计算灰度值上……
