//
//  DetailViewController.h
//  Ebay Code Challenge
//

#import <UIKit/UIKit.h>
#import "Pet.h"
#import "PetStore.h"

@interface DetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) Pet *detailItem;
@property (nonatomic, strong) PetStore *petStore;

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIPickerView *animalTypePicker;
@property (nonatomic, weak) IBOutlet UISegmentedControl *genderSegmentedControl;

@end

