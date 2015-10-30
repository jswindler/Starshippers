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
@property (strong, atomic) NSMutableArray *starships;

// filteredStarships is the filtered version of starships
@property (strong, atomic) NSMutableArray *filteredStarships;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.starships = [NSMutableArray array];
    self.filteredStarships = [NSMutableArray array];
    [self loadStarshipDataForUrl:[NSURL URLWithString:@"http://swapi.co/api/starships/"]];
  
    [self.searchTextField addTarget:self
                             action:@selector(searchTextFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];

    [self.minPriceTextField addTarget:self
                             action:@selector(priceTextFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];

    [self.maxPriceTextField addTarget:self
                               action:@selector(priceTextFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadStarshipDataForUrl:(NSURL *)url {
    // Create request
    // TODO: show a visual loading indicator
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     //NSLog(@"Response: %@", response);
                                     if (!error) {
                                         // Parse JSON response
                                         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                         NSArray *results = [result objectForKey:@"results"];
                                         if (results != nil) {
                                             for (NSDictionary *itemData in results) {
                                                 StarshipData *starship = [[StarshipData alloc] initWithDictionary:itemData];
                                                 [self.starships addObject:starship];
                                             }
                                         }
                                         
                                         id nextPage = [result objectForKey:@"next"];
                                         if (nextPage != nil && [nextPage isKindOfClass:[NSString class]]) {
                                             // get next page
                                             [self loadStarshipDataForUrl:[NSURL URLWithString:nextPage]];
                                         }
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self reloadAll];
                                         });
                                     }
                                     else {
                                         //TODO: Handle error case
                                     }
                                 }] resume];
}

- (void)updateSearchFiltering {
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
}

- (void)updatePriceSorting {
    NSArray *sortedArray;
    sortedArray = [self.filteredStarships sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger priceA = [(StarshipData *)a price];
        NSInteger priceB = [(StarshipData *)b price];
        NSComparisonResult sortResult = NSOrderedSame;
        if (priceA < priceB) {
            sortResult = NSOrderedAscending;
        }
        else if (priceB < priceA) {
            sortResult = NSOrderedDescending;
        }
        
        if (self.sortPriceSegmentedControl.selectedSegmentIndex == 1) {
            // reverse the sort
            if (sortResult == NSOrderedAscending) {
                sortResult = NSOrderedDescending;
            }
            else if (sortResult == NSOrderedDescending) {
                sortResult = NSOrderedAscending;
            }
        }
        
        return sortResult;
    }];
    
    self.filteredStarships = [NSMutableArray arrayWithArray:sortedArray];
}

- (void)updatePriceFiltering {
    unsigned long minPrice = 0;
    if (self.minPriceTextField.text.length > 0) {
        minPrice = self.minPriceTextField.text.longLongValue;
    }
    unsigned long maxPrice = ULONG_LONG_MAX;
    if (self.maxPriceTextField.text.length > 0) {
        maxPrice = self.maxPriceTextField.text.longLongValue;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (StarshipData *shipData in self.filteredStarships) {
        if (shipData.price >= minPrice &&
            shipData.price <= maxPrice) {
            [tempArray addObject:shipData];
        }
    }
    
    self.filteredStarships = tempArray;
}

- (void)reloadAll {
    self.filteredStarships = [NSMutableArray arrayWithArray:self.starships];
    
    [self updateSearchFiltering];
    [self updatePriceFiltering];
    [self updatePriceSorting];
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (IBAction)sortPriceValueChanged:(id)sender {
    [self reloadAll];
}

- (IBAction)keyboardDoneButtonPressed:(id)sender {
    // closes the keyboard
}

- (void)searchTextFieldDidChange:(id)sender {
    [self reloadAll];
}

- (void)priceTextFieldDidChange:(id)sender {
    [self reloadAll];
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
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld CR", (long)starship.price];
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
