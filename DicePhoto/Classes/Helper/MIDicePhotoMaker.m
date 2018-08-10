//
//  MIDicePhotoMaker.m
//  DicePhoto
//
//  Created by s3636586400 on 16/9/1.
//  Copyright © 2016年 MaskIsland. All rights reserved.
//

#import "MIDicePhotoMaker.h"
#import "MIDiceMaker.h"
#import "UIView+ColorOfPoint.h"

@interface MIDicePhotoMaker()

@property (nonatomic, strong) MIDiceMaker *diceMaker;

@property (nonatomic, assign) NSInteger diceSize;

@property (nonatomic, strong) NSMutableArray *dices;

@end

@implementation MIDicePhotoMaker

- (instancetype)init {
    self = [super init];
    self.quality  = HighQuality;
    //111
    self.diceSize = 16;
    
    [self setDice];
    
    return self;
}

- (void)setDice {
    self.dices    = [[NSMutableArray alloc] init];
    if (![UIImage imageNamed:[PATH_OF_DOCUMENT stringByAppendingString:@"/dice1"]]) {
        //没有筛子图片时，创建筛子图片
        MIDiceMaker *diceMaker = [MIDiceMaker instance];
        diceMaker.size = self.diceSize * 2;
        [diceMaker makeDice];
    }
    
    for (NSInteger i = 1; i < 7; i++) {
        UIImage *dice = [UIImage imageNamed:[NSString stringWithFormat:@"%@/dice%ld",PATH_OF_DOCUMENT,i]];
        [self.dices addObject:dice];
    }
}

- (void)makeDiceImageFromImageView:(UIImageView *)imageView {
    CGFloat subSize = self.quality;
    CGFloat diceSize = 16;
    NSInteger xCount = imageView.frame.size.width / subSize;
    NSInteger yCount = imageView.frame.size.height / subSize;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    //Save gray values
    NSMutableDictionary *grayData = [[NSMutableDictionary alloc] init];
    
    NSInteger threadCount   = 4;
    NSInteger jobForThread  = yCount / 4;
    for (NSInteger threadIndex = 0; threadIndex < threadCount; threadIndex++) {
        dispatch_group_async(group, queue, ^{
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSInteger y = threadIndex * jobForThread; y < threadIndex * jobForThread + jobForThread; y++) {
                NSMutableArray *rowGray = [[NSMutableArray alloc] init];
                for (NSInteger x = 0; x < xCount; x++) {
                    NSInteger averageGray = [self averageGrayFromImageView:imageView xIndex:x yIndex:y size:subSize];
                    [rowGray addObject:@(averageGray)];
                }
                [result addObject:rowGray];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [grayData setObject:result forKey:[NSString stringWithFormat:@"%ld",threadIndex]];
            });
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSMutableArray *fullGrayArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < threadCount; i++) {
            NSString *key = [NSString stringWithFormat:@"%ld",i];
            NSArray *threadResult = [grayData objectForKey:key];
            if (threadResult) [fullGrayArray addObjectsFromArray:threadResult];
        }
        UIGraphicsBeginImageContext(CGSizeMake(xCount * diceSize, yCount * diceSize));
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (NSInteger y = 0; y < jobForThread * 4; y++) {
            for (NSInteger x = 0; x < xCount; x++) {
                NSInteger grayValue = [fullGrayArray[y][x] integerValue];
                NSInteger diceIndex = [self getDiceIndexWithGray:grayValue];
                UIImage *dice = self.dices[diceIndex - 1];
                CGRect rect   = CGRectMake(x * diceSize, y * diceSize, diceSize, diceSize);
                CGContextDrawImage(context, rect, dice.CGImage);
            }
        }
        UIImage *diceImage = UIGraphicsGetImageFromCurrentImageContext();
        [self.delegate receiveDicePhotoImage:diceImage];
    });

}

//计算划分的图片小块的平均灰度值
- (CGFloat)averageGrayFromImageView:(UIImageView *)imageView
                             xIndex:(NSInteger)xIndex
                             yIndex:(NSInteger)yIndex
                               size:(NSInteger)size {
    CGFloat sum = 0;
    for (NSInteger y = yIndex * size; y < yIndex * size + size; y++) {
        for (NSInteger x = xIndex * size; x < xIndex * size + size; x++) {
            UIColor *color = [imageView colorOfPoint:CGPointMake(x, y)];
            CGFloat gray = [self grayFromColor:color];
            sum = sum + gray;
        }
    }
    
    return sum / size / size;
}

//计算UIColor灰度值
- (CGFloat)grayFromColor:(UIColor *)color {
    CGColorRef colorRef = color.CGColor;
    if (CGColorGetNumberOfComponents(colorRef) == 4) {
        const CGFloat *components = CGColorGetComponents(colorRef);
        CGFloat r = components[0] * 255;
        CGFloat g = components[1] * 255;
        CGFloat b = components[2] * 255;
        CGFloat gray = (r * 299 + g * 587 + b * 114 + 500) / 1000;
        return gray;
    }
    return 0;
}

//由灰度值分配筛子点数
- (NSInteger)getDiceIndexWithGray:(NSInteger)gary {
    if (gary < 0 || gary > 247) return 6;
    
    if (gary <= 41)     return 1;
    if (gary <= 83)     return 2;
    if (gary <= 124)    return 3;
    if (gary <= 165)    return 4;
    if (gary <= 206)    return 5;
    if (gary <= 247)    return 6;
    return 6;
}

@end
