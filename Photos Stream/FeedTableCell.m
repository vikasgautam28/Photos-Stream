//
//  FeedTableCell.m
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import "FeedTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
@interface FeedTableCell()

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic,strong) UIImageView *cellImageView;

@end

@implementation FeedTableCell
@synthesize containerView;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        containerView=[[UIView alloc] initWithFrame:CGRectMake(FEED_CELL_SIDE_PADDING, FEED_CELL_TOP_PADDING, SCREEN_WIDTH-2*FEED_CELL_SIDE_PADDING, FEED_CELL_HEIGHT-FEED_CELL_TOP_PADDING)];
        [containerView setBackgroundColor:[UIColor whiteColor]];
        containerView.layer.cornerRadius=3.f;
        containerView.layer.masksToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(FEED_CELL_SIDE_PADDING, 0, SCREEN_WIDTH-4*FEED_CELL_SIDE_PADDING, 20)];
        self.descriptionLabel.textAlignment=NSTextAlignmentCenter;
        [self.descriptionLabel setFont:[UIFont fontWithName:FONT size:14]];
        self.cellImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.descriptionLabel.frame.size.height, SCREEN_WIDTH-2*FEED_CELL_SIDE_PADDING, FEED_CELL_HEIGHT-FEED_CELL_TOP_PADDING-self.descriptionLabel.frame.size.height)];
        
        self.cellImageView.layer.cornerRadius=3.f;
        
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.imageView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:containerView];
        
        [containerView addSubview:self.descriptionLabel];
        [containerView addSubview:self.cellImageView];
        
    }
    
    return self;
}

-(void)updateCellForReuseWithJSON:(NSDictionary*) dictionary {
    self.cellImageView.image=nil;
    self.descriptionLabel.text=[dictionary objectForKey:@"title"];
    
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"url"]]
                 placeholderImage:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                            
                            
                            //[loaderView stopAnimating];
                            
                        }];

}

@end
