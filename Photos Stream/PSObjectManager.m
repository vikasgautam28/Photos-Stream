//
//  PSObjectManager.m
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import "PSObjectManager.h"
#import <AFHTTPRequestOperation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation PSObjectManager



static PSObjectManager * objectManager=nil; //

+(PSObjectManager*) getManager {
    
    if(objectManager==nil)
    {
        
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            objectManager = [[PSObjectManager alloc] init];
        });
    }
    
    return objectManager;
}


- (void) setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void) getObjectsFromURL:(NSString *)dataURL withParams:(NSDictionary*) params {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    [manager GET:dataURL   parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //[self printCookies];
        
        //NSLog(@" Response :%@",responseObject);
        if([delegate respondsToSelector:@selector(didLoadObjectsfromURL:fetchedResponseObject:)]) {
            [delegate didLoadObjectsfromURL:dataURL fetchedResponseObject:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"Error: %@", error);
        
        if([delegate respondsToSelector:@selector(didFailToLoadObjectsfromURL:fetchedResponseObject:)]) {
            [delegate didFailToLoadObjectsfromURL:dataURL fetchedResponseObject:error];
        }
        
    }];
    
    
}


@end
