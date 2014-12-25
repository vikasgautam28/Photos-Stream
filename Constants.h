//
//  Constants.h
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>
#define URL @"https://raw.githubusercontent.com/rish2cool/IOSChallenge/master/response.json"

#define LIGHT_GRAY_COLOR @"D8D8D8"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FEED_CELL_TOP_PADDING 10
#define FEED_CELL_SIDE_PADDING 10
#define FEED_CELL_HEIGHT 280
#define DESCRIPTION_LABEL_HEIGHT 50
#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define FONT @"HelveticaNeue"
@interface Constants : NSObject

@end
