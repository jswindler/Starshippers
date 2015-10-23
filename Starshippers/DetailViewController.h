//
//  DetailViewController.h
//  Starshippers
//
//  Created by Joe Swindler on 10/22/15.
//  Copyright © 2015 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

