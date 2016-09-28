//
//  MIDiceMaker.h
//  DicePhoto
//
//  Created by s3636586400 on 16/9/1.
//  Copyright © 2016年 MaskIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


///create dice photo 
@interface MIDiceMaker : NSObject

@property (nonatomic, assign) CGFloat size;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *foregroundColor;

@property (nonatomic, assign) BOOL hasBorder;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) NSArray *diceMap;

+ (instancetype)instance;

- (void)makeDice;

@end
