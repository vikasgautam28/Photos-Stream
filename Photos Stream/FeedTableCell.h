//
//  FeedTableCell.h
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableCell : UITableViewCell
-(void)updateCellForReuseWithJSON:(NSDictionary*) dictionary;
@end
