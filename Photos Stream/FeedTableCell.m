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
#import "AppDelegate.h"
#define IMAGE_FRAME_REDUCE_FACTOR 0.5

@interface FeedTableCell() {
    UIActivityIndicatorView * spinner;

        
        NSManagedObjectContext *context;

}

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic,strong) UIImageView *cellImageView;
@property (assign, nonatomic) CATransform3D initialTransformation;

@end

@implementation FeedTableCell
@synthesize containerView;
@synthesize initialTransformation;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        context = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) managedObjectContext];
        [self setBackgroundColor:[UIColor clearColor]];
        
        containerView=[[UIView alloc] initWithFrame:CGRectMake(FEED_CELL_SIDE_PADDING, FEED_CELL_TOP_PADDING, SCREEN_WIDTH-2*FEED_CELL_SIDE_PADDING, FEED_CELL_HEIGHT-FEED_CELL_TOP_PADDING)];
        [containerView setBackgroundColor:[UIColor whiteColor]];
        containerView.layer.cornerRadius=3.f;
        containerView.layer.masksToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(FEED_CELL_SIDE_PADDING, 0, SCREEN_WIDTH-4*FEED_CELL_SIDE_PADDING, DESCRIPTION_LABEL_HEIGHT)];
        self.descriptionLabel.textAlignment=NSTextAlignmentCenter;
        [self.descriptionLabel setFont:[UIFont fontWithName:FONT size:16]];
        self.cellImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, DESCRIPTION_LABEL_HEIGHT, SCREEN_WIDTH-2*FEED_CELL_SIDE_PADDING, FEED_CELL_HEIGHT-FEED_CELL_TOP_PADDING-DESCRIPTION_LABEL_HEIGHT)];
        
        self.cellImageView.layer.cornerRadius=3.f;
        
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.imageView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:containerView];
        
        [containerView addSubview:self.descriptionLabel];
        [containerView addSubview:self.cellImageView];
        
        spinner=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.cellImageView.frame.size.width/2, self.cellImageView.frame.size.height/2, 1, 1)];
        spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [self.cellImageView addSubview:spinner];
        CGFloat rotationAngleRadians = M_PI;
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, rotationAngleRadians, 1.0, 0.0, 0.0);
        initialTransformation = transform;
        
    }
    
    return self;
}

-(void) animateImageView {
    
                    self.cellImageView.layer.transform = self.initialTransformation;
    
                    [UIView animateWithDuration:1 animations:^{
                        self.cellImageView.layer.transform = CATransform3DIdentity;
                    }];
}

-(void)updateCellForReuseWithPhoto:(Photo*) photo {
    self.cellImageView.image=nil;
    self.descriptionLabel.text=photo.title;//[dictionary objectForKey:@"title"];
    CGRect imageViewFrame=self.cellImageView.frame;
    
    [spinner startAnimating];
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:photo.url]
                 placeholderImage:nil
                                   options:SDWebImageCacheMemoryOnly
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                            
                                [spinner stopAnimating];
                            if(image && cacheType==SDImageCacheTypeNone) {
                                ((AppDelegate*)[[UIApplication sharedApplication] delegate]).totalImagesLoaded=@([[((AppDelegate*)[[UIApplication sharedApplication] delegate]) totalImagesLoaded] intValue]+1);
                                
                                self.cellImageView.frame=CGRectMake(0, 0, imageViewFrame.size.width*IMAGE_FRAME_REDUCE_FACTOR, imageViewFrame.size.height*IMAGE_FRAME_REDUCE_FACTOR);
                                self.cellImageView.alpha = 0.0;
                                [UIView transitionWithView:self.cellImageView
                                                  duration:0.5
                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                animations:^{
                                                    [self.cellImageView setImage:image];
                                                    self.cellImageView.alpha = 1.0;
                                                    self.cellImageView.frame=imageViewFrame;
                                                } completion:NULL];
                            } else {
                                self.cellImageView.alpha=1.0;
                                [self.cellImageView setImage:image];
                            }
                           
                            [self updateCoreDataObjects:photo andImage:self.cellImageView.image];
                            
                        }];

}

-(void)updateCoreDataObjects:(Photo*)photo andImage:(UIImage*)image {
    
   NSUInteger imageSize= CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoId == %@",photo.photoId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *results=[context executeFetchRequest:request error:&error];
    if([results count]>0) {
        
        Photo *fetchedObject=[results objectAtIndex:0];
        fetchedObject.sizeBytes= [NSNumber numberWithLong:imageSize];
        fetchedObject.width=[NSNumber numberWithLong:image.size.width];
        fetchedObject.height=[NSNumber numberWithLong:image.size.height];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
    }
    
//    NSManagedObject *photoObject = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Photo"
//                              inManagedObjectContext:context];

    
}

@end
