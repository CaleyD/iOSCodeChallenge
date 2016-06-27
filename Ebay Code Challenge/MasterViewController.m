//
//  MasterViewController.m
//  Ebay Code Challenge
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PetStore.h"

@interface MasterViewController () <UISearchResultsUpdating>

@property NSArray *pets;
@property NSArray *searchResults;
@property PetStore *petStore;
@property (nonatomic, strong) UIActivityIndicatorView * loadingIndicator;
@property (nonatomic, strong) UISearchController * searchController;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.petStore = [[PetStore alloc] init];
    
    [self showLoadingIndicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray * pets = [[self.petStore getAllPets] sortedArrayUsingDescriptors:@[sort]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pets = pets;
            
            [self hideLoadingIndicator];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        });
    });
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    
    // in case properties were modified by the detail view
    [self doTextSearch];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

#pragma mark - Loading indicator

- (void)showLoadingIndicator {
    if(!self.loadingIndicator) {
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.loadingIndicator.center = self.view.center;
        self.loadingIndicator.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:self.loadingIndicator];
    }
    
    [self.loadingIndicator startAnimating];
}

- (void)hideLoadingIndicator {
    [self.loadingIndicator stopAnimating];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Pet *pet = self.pets[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.detailItem = pet;
        controller.petStore = self.petStore;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchResults != nil) {
        return self.searchResults.count;
    }
    return self.pets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Pet * pet = (self.searchResults != nil) ? self.searchResults[indexPath.row] : self.pets[indexPath.row];
    cell.textLabel.text = pet.name;
    cell.detailTextLabel.text = pet.animalType;

    return cell;
}

# pragma - search

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self doTextSearch];
    [self.tableView reloadData];
}

- (void)doTextSearch {
    NSString * text = self.searchController.searchBar.text;
    if(text == nil || text.length == 0) {
        self.searchResults = nil;
    } else {
        NSPredicate *textSearch = [NSPredicate predicateWithBlock:^BOOL(Pet *pet, NSDictionary *bindings) {
            return
                ([pet.name rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([pet.animalType rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound);
        }];
    
        self.searchResults = [self.pets filteredArrayUsingPredicate:textSearch];}
    }
@end
