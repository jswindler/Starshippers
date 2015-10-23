//
//  StarshipCollectionViewCell.h
//  Starshippers
//
//  Created by Joe on 10/22/15.
//  Copyright (c) 2015 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarshipCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *priceLabel;

@end
