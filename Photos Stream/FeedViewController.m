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
@interface FeedViewController()<UITableViewDataSource,UITableViewDelegate,LoadDataDelegate>
@property (nonatomic,strong) UITableView *feedTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) LoadData *loadData;
@end

@implementation FeedViewController

@synthesize feedTableView;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray=[[NSArray alloc] init];
    
    self.loadData=[[LoadData alloc] init];
    [self.loadData setDelegate:self];
    
    [self.loadData retriveObjects];
    
    [self addFeedTableView];
    
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



-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
