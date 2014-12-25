//
//  User.h
//  Photos Stream
//
//  Created by Vikas on 25/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * userNumber;
@property (nonatomic, retain) Photo *photo;

@end
