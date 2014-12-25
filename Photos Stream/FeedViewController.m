//
//  FeedViewController.m
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import "FeedViewController.h"
#import "Constants.h"
#import "PSObjectManager.h"
#import "CommonFunctions.h"
#import "FeedTableCell.h"
#import "AppDelegate.h"
#import "LoadData.h"
#import "Photo.h"
#define CELL_REUSE_IDENTIFIER @"feedCell"
@interface FeedViewController()<UITableViewDataSource,UITableViewDelegate,LoadDataDelegate> {
    NSManagedObjectContext *context;
    BOOL statisticsPrinted;
}
@property (nonatomic,strong) UITableView *feedTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) LoadData *loadData;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@end

@implementation FeedViewController
@synthesize spinner;
@synthesize feedTableView;

-(void)viewDidLoad {
    [super viewDidLoad];
    statisticsPrinted=false;
    context = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) managedObjectContext];
    
    self.dataArray=[[NSArray alloc] init];
    
    self.loadData=[[LoadData alloc] init];
    [self.loadData setDelegate:self];
    
    spinner=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    spinner.center=self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [self.loadData retriveObjects];
    
    [self addFeedTableView];
    
    [self.view bringSubviewToFront:spinner];
    
    [self.view setBackgroundColor:[CommonFunctions colorWithHexString:LIGHT_GRAY_COLOR]];
}


-(void)addFeedTableView {
    
    self.feedTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-STATUSBAR_HEIGHT) style:UITableViewStylePlain];
    [self.feedTableView setBackgroundColor:[UIColor clearColor]];
    self.feedTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.feedTableView.delegate=self;
    self.feedTableView.dataSource=self;
    self.feedTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    [self.feedTableView registerClass:[FeedTableCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
    
    [self.view addSubview:feedTableView];

}

-(void)retrivedObjects:(NSArray *)dataArray {
    [spinner stopAnimating];
    self.dataArray=dataArray;
    
    [self.feedTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedTableCell *cell=[self.feedTableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    [cell updateCellForReuseWithPhoto:[self.dataArray objectAtIndex:indexPath.row]];
 
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==[self.dataArray count]-1 && !statisticsPrinted) {
        int totalimagesLoaded=[[((AppDelegate*)[[UIApplication sharedApplication] delegate]) totalImagesLoaded] intValue];
        
        if(totalimagesLoaded==[self.dataArray count]) {
            
            statisticsPrinted=true;
            [self generateStatistics];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==[self.dataArray count]-1) {
        
        return FEED_CELL_TOP_PADDING+FEED_CELL_HEIGHT;
    } else {
    
        return FEED_CELL_HEIGHT;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [((FeedTableCell*)[tableView cellForRowAtIndexPath:indexPath]) animateImageView];
}

-(void) generateStatistics {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSError *error;
    
    NSArray *results=[context executeFetchRequest:request error:&error];
    
    
    
    for(User *user in results) {
        NSLog(@"User Name: user %@",user.userNumber);
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@",user];
        [request setPredicate:predicate];
        NSError *error;
        
        NSArray *photos=[context executeFetchRequest:request error:&error];

        NSLog(@"No. of Entries: %lu",(unsigned long)[photos count]);
        int totalImageSize=0;
        int greatestImageWidth=0;
        if([photos count]>0) {
            
            for(Photo *photo in photos) {
                
                totalImageSize+=[photo.sizeBytes intValue];
                
                if([photo.width integerValue]>=greatestImageWidth) {
                    
                    greatestImageWidth=[photo.width intValue];
                }
            }
            
        }
        
        NSLog(@"Avg. Image Size (kb) : %lu",(totalImageSize/1024)/[photos count]);
        NSLog(@"Greatest Photo width : %d",greatestImageWidth);
        
        
        
    }
}


-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
