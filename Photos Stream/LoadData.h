//
//  LoadData.h
//  Photos Stream
//
//  Created by Vikas on 25/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadDataDelegate

@required

-(void) retrivedObjects:(NSArray*) dataArray;


@end


@interface LoadData : NSObject{
    
    id delegate;
}

-(void) retriveObjects;

- (void) setDelegate:(id)newDelegate;

@end
