//
//  LoadData.m
//  Photos Stream
//
//  Created by Vikas on 25/12/14.
//  Copyright (c) 2014 Vikas Gautam. All rights reserved.
//

#import "LoadData.h"
#import "AppDelegate.h"
#import "PSObjectManager.h"
#import "Constants.h"
@interface LoadData()<PSObjectDelegate> {
    
    NSManagedObjectContext *context;
}

@property (nonatomic,strong) PSObjectManager *objectManager;


@end


@implementation LoadData
@synthesize objectManager;


-(id) init {
    
    self=[super init];
    
    if(self) {
        context = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) managedObjectContext];
        objectManager=[PSObjectManager getManager];
        
        [objectManager setDelegate:self];
    }
    
    return self;
}

- (void) setDelegate:(id)newDelegate {
    delegate = newDelegate;
}


-(NSArray*) fetchObjectFromCoreData {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Photo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}



-(void) retriveObjects {
   NSArray *fetchedObjects=[self fetchObjectFromCoreData];
    if([fetchedObjects count]>0) {
        
        if([delegate respondsToSelector:@selector(retrivedObjects:)]) {
        
            [delegate retrivedObjects:fetchedObjects];
        }
    } else {
        
        [self loadData];
    }
    
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSManagedObject *details = [info valueForKey:@"details"];
//        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
//    }

    
}

-(void) loadData {
    
    [objectManager getObjectsFromURL:URL withParams:@{}];
   

}

-(void)didLoadObjectsfromURL:(NSString *)dataURL fetchedResponseObject:(id)responseObject {
    
    NSArray* dataArray=[responseObject objectForKey:@"photos"];
    
    for( NSDictionary * imageInfo in dataArray) {
        
      
        
        NSManagedObject *photo = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Photo"
                                  inManagedObjectContext:context];
        [photo setValue:[imageInfo objectForKey:@"id"] forKey:@"id"];
        [photo setValue:[imageInfo objectForKey:@"title"] forKey:@"title"];
        [photo setValue:[imageInfo objectForKey:@"url"] forKey:@"url"];
        NSManagedObject *user = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"User"
                                 inManagedObjectContext:context];
        [user setValue:[imageInfo objectForKey:@"user"] forKey:@"userNumber"];
        [photo setValue:user forKey:@"user"];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    NSArray *fetchedObjects=[self fetchObjectFromCoreData];
    
    if([fetchedObjects count]>0) {
        
        if([delegate respondsToSelector:@selector(retrivedObjects:)]) {
            
            [delegate retrivedObjects:fetchedObjects];
        }
    }
    
    NSLog(@"success: %@",responseObject);
}


-(void) didFailToLoadObjectsfromURL:(NSString *)dataURL fetchedResponseObject:(id)error {
    NSLog(@"Failure: %@",error);
}


@end
