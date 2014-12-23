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

#define CELL_REUSE_IDENTIFIER @"feedCell"
@interface FeedViewController()<PSObjectDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) PSObjectManager *objectManager;
@property (nonatomic,strong) UITableView *feedTableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation FeedViewController
@synthesize objectManager;
@synthesize feedTableView;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray=[[NSArray alloc] init];
    objectManager=[PSObjectManager getManager];
    
    [objectManager setDelegate:self];
    [self loadData];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedTableCell *cell=[self.feedTableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    [cell updateCellForReuseWithJSON:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return FEED_CELL_HEIGHT;
}


-(void) loadData {
    
    [objectManager getObjectsFromURL:URL withParams:@{}];
}

-(void)didLoadObjectsfromURL:(NSString *)dataURL fetchedResponseObject:(id)responseObject {
    
    self.dataArray=[responseObject objectForKey:@"photos"];
    [self.feedTableView reloadData];
    NSLog(@"success: %@",responseObject);
}

-(void) didFailToLoadObjectsfromURL:(NSString *)dataURL fetchedResponseObject:(id)error {
    NSLog(@"Failure: %@",error);
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
