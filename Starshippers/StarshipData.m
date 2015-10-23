//
//  StarshipData.m
//  Starshippers
//
//  Created by Joe Swindler on 10/22/15.
//  Copyright © 2015 Joe. All rights reserved.
//

#import "StarshipData.h"

@implementation StarshipData

- (id)initWithDictionary:(NSDictionary *)dict
{
  if (self = [super init]) {
    self.name = [dict objectForKey:@"name"];
    NSString *priceStr = [dict objectForKey:@"cost_in_credits"];
    self.price = priceStr.integerValue;
    self.url = [dict objectForKey:@"url"];
    self.pilots = [NSMutableArray arrayWithArray:[dict objectForKey:@"pilots"]];
    
    // TODO: Get an image!
    //NSMutableString *imageStr = [NSMutableString stringWithString:[dict objectForKey:@"image"]];
    //NSURL *imageUrl = [NSURL URLWithString:imageStr];
    //self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
  }
  
  return self;
}

@end
