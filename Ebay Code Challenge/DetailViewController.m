//
//  DetailViewController.m
//  Ebay Code Challenge
//

#import "DetailViewController.h"
#import "Pet.h"

@interface DetailViewController ()
@property (nonatomic, strong) NSArray *animalTypes;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    _detailItem = newDetailItem;
    [self configureView];
}

- (void)configureView {
    if (self.detailItem) {
        self.nameTextField.text = self.detailItem.name;
        
        self.genderSegmentedControl.selectedSegmentIndex = self.detailItem.gender == GenderMale ? 0 : 1;
        
        [self.animalTypePicker selectRow:[self.animalTypes indexOfObject:self.detailItem.animalType] inComponent:0 animated:YES];
        [self.animalTypePicker reloadComponent:0];
        
    }
    [self disableSave];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animalTypes = [self.petStore getAvailableAnimalTypes];
    
    [self.nameTextField addTarget:self
                           action:@selector(enableSave)
                 forControlEvents:UIControlEventEditingChanged];
    
    [self.nameTextField addTarget:self
                           action:@selector(dismissKeyboardOnDone:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.genderSegmentedControl addTarget:self action:@selector(enableSave) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePet:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.animalTypePicker.dataSource = self;
    self.animalTypePicker.delegate = self;
    
    [self configureView];
}

- (void)dismissKeyboardOnDone:(id)sender {
    [sender resignFirstResponder];
}

- (void)enableSave {
    bool isFormComplete = self.nameTextField.text.length > 0;
    self.navigationItem.rightBarButtonItem.enabled = isFormComplete;
}
- (void)disableSave {
    self.navigationItem.rightBarButtonItem.enabled = false;
}

- (void)savePet:(id)sender {
    self.detailItem.name = self.nameTextField.text;
    self.detailItem.animalType = [self pickerView:self.animalTypePicker titleForRow:[self.animalTypePicker selectedRowInComponent:0] forComponent:0];
    self.detailItem.gender = self.genderSegmentedControl.selectedSegmentIndex == 0 ? GenderMale : GenderFemale;
    
    // save silently in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.petStore savePet:self.detailItem];
    });
    [self disableSave];
}

# pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.animalTypes.count;
}

# pragma mark - UIPickerViewDelegate

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.animalTypes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self enableSave];
}

@end
