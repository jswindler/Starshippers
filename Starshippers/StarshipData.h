//
//  StarshipData.h
//  Starshippers
//
//  Created by Joe Swindler on 10/22/15.
//  Copyright © 2015 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StarshipData : NSObject

@property(atomic, strong) UIImage *image;
@property(atomic, copy) NSString *name;
@property(atomic, assign) unsigned long price;
@property(atomic, copy) NSString *url;
@property(atomic, copy) NSMutableArray *pilots;
@property(atomic, copy) NSString *model;
@property(atomic, copy) NSString *manufacturer;
@property(atomic, copy) NSString *length;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
