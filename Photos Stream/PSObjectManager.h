//
//  PSObjectManager.h
//  Photos Stream
//
//  Created by Vikas on 23/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PSObjectDelegate

@required

-(void) didLoadObjectsfromURL:(NSString*) dataURL fetchedResponseObject:(id) responseObject;

-(void) didFailToLoadObjectsfromURL:(NSString*)dataURL fetchedResponseObject:(id)error;

@end


@interface PSObjectManager : NSObject{
    
    id delegate;
}

+ (PSObjectManager*) getManager;

- (void) setDelegate:(id)newDelegate;
-(void) getObjectsFromURL:(NSString *)dataURL withParams:(NSDictionary*) params;

@end
