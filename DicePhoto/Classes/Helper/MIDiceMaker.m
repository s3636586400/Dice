//
//  MIDiceMaker.m
//  DicePhoto
//
//  Created by s3636586400 on 16/9/1.
//  Copyright © 2016年 MaskIsland. All rights reserved.
//

#import "MIDiceMaker.h"

@implementation MIDiceMaker

+ (instancetype)instance {
    static MIDiceMaker *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MIDiceMaker alloc] init];
    });
    return instance;
}

//make all dices
- (void)makeDice {
    for (NSInteger i = 1; i <= 6; i++) {
        [self makeDice:i];
    }
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    [self defaultConfig];
    return self;
}

- (void)defaultConfig {
    _size = 32.0;
    _backgroundColor = UIColorFromHex(0x333333);
    _foregroundColor = [UIColor whiteColor];
    _hasBorder       = YES;
    _borderColor     = [UIColor blackColor];
    _diceMap = @[@[@4],@[@2,@6],@[@2,@4,@6],@[@0,@2,@6,@8],@[@0,@2,@4,@6,@8],@[@0,@2,@3,@5,@6,@8]];
}

//make dice
- (void)makeDice:(NSInteger)dice {
    CGRect rect = CGRectZero;
    CGFloat circleWidth = 0;
    UIGraphicsBeginImageContext(CGSizeMake(_size, _size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_hasBorder) {
        //border
        CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
        CGContextAddRect(context, CGRectMake(0, 0, _size, _size));
        CGContextStrokePath(context);
        
        circleWidth = (_size - 2 - 4) / 3;
        rect = CGRectMake(1, 1, _size - 2, _size - 2);
    }else {
        circleWidth = (_size - 4) / 3;
        rect = CGRectMake(0, 0, _size, _size);
    }
    //bgColor
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    //circle
    NSArray *diceCircles = _diceMap[dice - 1];
    for (NSNumber *circleIndex in diceCircles) {
        [self drawCircleInIndex:[circleIndex integerValue] Context:context circleWidth:circleWidth];
    }
    //save
    UIImage *diceImage  = UIGraphicsGetImageFromCurrentImageContext();
    NSData *data        = UIImagePNGRepresentation(diceImage);
    NSString *path = [NSString stringWithFormat:@"%@/dice%ld.png",PATH_OF_DOCUMENT,dice];
    [data writeToFile:path atomically:YES];
    UIGraphicsEndImageContext();
}

//draw circle
- (void)drawCircleInIndex:(NSInteger)index
                  Context:(CGContextRef)context
              circleWidth:(CGFloat)circleWidth {
    NSInteger x = index % 3;
    NSInteger y = index / 3;
    NSInteger start = 2 + (_hasBorder ? 1 : 0);
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(start + x * circleWidth, start + y * circleWidth, circleWidth, circleWidth));
    CGContextFillPath(context);
}

@end
