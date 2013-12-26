//
//  BNRItem.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/25/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNRItem : NSManagedObject

@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, strong) NSString * imageKey;
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSString * serialName;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData * thumbnailData;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailDataFromImage:(UIImage *)image;
+ (id)randomItem;
- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
            serialName:(NSString *)sName;

@end
