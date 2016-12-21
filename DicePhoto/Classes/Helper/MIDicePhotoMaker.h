//
//  MIDicePhotoMaker.h
//  DicePhoto
//
//  Created by s3636586400 on 16/9/1.
//  Copyright © 2016年 MaskIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HighQuality = 4,    //高
    LowQuality  = 8     //低
} DiceImageQuality;     //图片质量

@protocol DicePhotoMakerDelegate <NSObject>

- (void)receiveDicePhotoImage:(UIImage *)image;

@end

@interface MIDicePhotoMaker : NSObject

@property (nonatomic, assign) DiceImageQuality quality;

@property (nonatomic, weak) id<DicePhotoMakerDelegate> delegate;

- (void)makeDiceImageFromImageView:(UIImageView *)imageView;

@end
