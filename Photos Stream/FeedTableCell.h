//
//  FeedTableCell.h
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
@interface FeedTableCell : UITableViewCell
-(void)updateCellForReuseWithPhoto:(Photo*) photo;
-(void) animateImageView;
@end
