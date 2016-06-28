//
//  MasterViewController.m
//  Ebay Code Challenge
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PetStore.h"

@interface MasterViewController () <UISearchResultsUpdating>

@property NSArray *pets;
@property NSArray *categorizedPets;
@property PetStore *petStore;
@property (nonatomic, strong) UIActivityIndicatorView * loadingIndicator;
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSArray *sections;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.petStore = [[PetStore alloc] init];
    self.sections = [self.petStore getAvailableAnimalTypes];
    
    [self showLoadingIndicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray * pets = [[self.petStore getAllPets] sortedArrayUsingDescriptors:@[sort]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pets = pets;
            
            // put pets in a more convenient data format for sorting by animal type

            [self setFriendlyDataSource];
            [self hideLoadingIndicator];
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
    
    [self setFriendlyDataSource];
    
    [super viewWillAppear:animated];
}

- (void)setFriendlyDataSource {
    NSArray * pets;
    
    NSString * searchText = self.searchController.searchBar.text;
    if(searchText == nil || searchText.length == 0) {
        pets = self.pets;
    } else {
        NSPredicate *textSearch = [NSPredicate predicateWithBlock:^BOOL(Pet *pet, NSDictionary *bindings) {
            return ([pet.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound);
        }];
        pets = [self.pets filteredArrayUsingPredicate:textSearch];
    }
    
    NSMutableDictionary *petsByAnimal = [[NSMutableDictionary alloc] init];
    for(int i=0; i<pets.count; ++i) {
        Pet *pet = pets[i];
        
        NSMutableArray *animalsOfType = [petsByAnimal objectForKey:pet.animalType];
        if(animalsOfType == nil) {
            animalsOfType = [[NSMutableArray alloc] init];
            [petsByAnimal setObject:animalsOfType forKey:pet.animalType];
        }
        [animalsOfType addObject:pet];
    }
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for(int i=0; i<self.sections.count; ++i) {
        NSString *section = self.sections[i];
        NSMutableArray *animalsOfType = [petsByAnimal objectForKey:section];
        if(animalsOfType !=nil && animalsOfType.count > 0) {
            [categories addObject:@[section, animalsOfType]];
        }
    }
    
    self.categorizedPets = categories;
    [self.tableView reloadData];
}

#pragma mark - Loading indicator

- (void)showLoadingIndicator {
    if(!self.loadingIndicator) {
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.loadingIndicator.center = self.view.center;
        self.loadingIndicator.backgroundColor = UIColor.clearColor;
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
        Pet *pet = self.categorizedPets[indexPath.section][1][indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.detailItem = pet;
        controller.petStore = self.petStore;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categorizedPets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.categorizedPets[section][1]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *petsInCategory = self.categorizedPets[indexPath.section][1];
    
    Pet *pet = petsInCategory[indexPath.row];
    cell.textLabel.text = pet.name;
    cell.detailTextLabel.text = pet.gender == GenderMale ? @"male" : @"female";

    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];

    NSString *animalType = self.categorizedPets[section][0];
    
    UILabel *title = [headerView viewWithTag:546];
    title.text = [NSString stringWithFormat:@"%@s", animalType];
    
    UIImageView *img = [headerView viewWithTag:547];
    // NOTE - purposely letting the image overflow the rounded container for effect
    img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", animalType]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

# pragma - search

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self setFriendlyDataSource];
}

@end
