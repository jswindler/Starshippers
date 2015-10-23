//
//  MasterViewController.m
//  Starshippers
//
//  Created by Joe Swindler on 10/22/15.
//  Copyright © 2015 Joe. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "StarshipData.h"
#import "StarshipCollectionViewCell.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *minPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxPriceTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortPriceSegmentedControl;

// starships is the underlying data source
@property NSMutableArray *starships;

// filteredStarships is the filtered version of starships
@property NSMutableArray *filteredStarships;

@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.starships = [NSMutableArray array];
  self.filteredStarships = [NSMutableArray array];
  [self loadStarshipData];
  
  [self.searchTextField addTarget:self
                action:@selector(searchTextFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadStarshipData {
  // Create request
  NSURL *url = [NSURL URLWithString:@"http://swapi.co/api/starships/"];
  //TODO: Get remaining pages of results
  
  // show a visual loading indicator
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  [[[NSURLSession sharedSession] dataTaskWithURL:url
                              completionHandler:^(NSData *data,
                                                  NSURLResponse *response,
                                                  NSError *error) {
                                NSLog(@"Response: %@", response);
                                if (!error) {
                                  // Parse JSON response
                                  NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                  
                                  NSArray *results = [result objectForKey:@"results"];
                                  if (results != nil) {
                                    for (NSDictionary *itemData in results) {
                                      StarshipData *starship = [[StarshipData alloc] initWithDictionary:itemData];
                                      [self.starships addObject:starship];
                                    }
                                    
                                    self.filteredStarships = [NSMutableArray arrayWithArray:self.starships];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                      [self.collectionView reloadData];
                                    });
                                  }
                                }
                                else {
                                  //TODO: Handle error case
                                }
                              }] resume];
}

#pragma mark - Actions

- (IBAction)sortPriceValueChanged:(id)sender {
}

- (void)searchTextFieldDidChange:(id)sender {
  
  if (self.searchTextField.text.length == 0) {
    // reset the filter
    self.filteredStarships = [NSMutableArray arrayWithArray:self.starships];
  }
  else {
    // filter the search results
    NSArray *searchTerms = [self.searchTextField.text componentsSeparatedByString:@" "];
    self.filteredStarships = [NSMutableArray array];
    for (StarshipData *starship in self.starships) {
      BOOL isMatch = YES;
      for (NSString *searchTerm in searchTerms) {
        NSString *trimmedString = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedString.length > 0 && ![starship.name.lowercaseString containsString:trimmedString.lowercaseString]) {
          isMatch = NO;
          break;
        }
      }
      
      if (isMatch) {
        [self.filteredStarships addObject:starship];
      }
    }
  }
  
  [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.filteredStarships.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  StarshipCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  StarshipData *starship = [self.filteredStarships objectAtIndex:indexPath.row];
  if (starship != nil) {
    cell.nameLabel.text = starship.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld", (long)starship.price];
    if (starship.image != nil) {
      cell.imageView.image = starship.image;
    }
    else {
      cell.imageView.image = [UIImage imageNamed:@"comingsoon"];
    }
  }
  
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  StarshipData *starship = [self.filteredStarships objectAtIndex:indexPath.row];
  if (starship != nil) {
    DetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    if (detailView != nil) {
      detailView.starshipData = starship;
      [self.navigationController pushViewController:detailView animated:YES];
    }
  }
}

@end
