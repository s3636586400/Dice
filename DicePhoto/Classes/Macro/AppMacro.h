//
//  AppMacro.h
//  DicePhoto
//
//  Created by s3636586400 on 16/9/1.
//  Copyright © 2016年 MaskIsland. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#pragma mark UIColor

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)

#pragma mark - UIScreen

#define  STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define  SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define  SCREEN_HEIGHT_EXCEPTSTATUS (SCREEN_HEIGHT - STATUS_BAR_HEIGHT)
#define  SCREEN_HEIGHT_EXCEPTNAV (SCREEN_HEIGHT - 64.0f)


#endif /* AppMacro_h */
