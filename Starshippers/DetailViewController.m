//
//  DetailViewController.m
//  Starshippers
//
//  Created by Joe Swindler on 10/22/15.
//  Copyright © 2015 Joe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController


- (void)viewDidLoad {
  [super viewDidLoad];

  if (self.starshipData != nil) {
    self.nameLabel.text = self.starshipData.name;
    self.modelLabel.text = self.starshipData.model;
    self.manufacturerLabel.text = self.starshipData.manufacturer;
    self.costLabel.text = [NSString stringWithFormat:@"%ld", (long)self.starshipData.price];
    self.lengthLabel.text = self.starshipData.length;

    // TODO: Google image search by ship name
    //    self.imageView.image =
  }
}

@end
