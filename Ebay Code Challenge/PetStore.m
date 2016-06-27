//
//  PetStore.m
//  Ebay Code Challenge
//
// Not botherig to code for edge cases (saving invalid pet) because this is a dummy data source
// This does account for thread safety because we are intentionally running this on a non-UI thread as part of the challenge
// This also doesn't support adding or deleting (ony retrieving and updating) because of the scope of the challenge.

#import <Foundation/Foundation.h>
#import "Pet.h"
#import "PetStore.h"

@interface PetStore ()
@property (nonatomic, strong) NSMutableDictionary *pets;
@property (nonatomic) int nextPetId;
@end

@implementation PetStore

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _nextPetId = 0;
    
    // initialize with dummy data
    _pets = [[NSMutableDictionary alloc] init];
    
    NSArray *femaleNames = @[@"Bella", @"Molly", @"Ruby", @"Coco", @"Lucy", @"Rosie", @"Daisy", @"Millie", @"Tilly", @"Roxy", @"CiCi"];
    NSArray *maleNames = @[@"Charlie", @"Max", @"Buddy", @"Archie", @"Oscar", @"Toby", @"Ollie", @"Jack", @"Bailey", @"Milo", @"Slobbers"];
    NSArray *malePrefixes = @[@"", @"Sir ", @"Mr ", @"Big "];
    NSArray *femalePrefixes = @[@"", @"Miss ", @"Lil' "];
    NSArray *animals = @[@"Dog", @"Cat", @"Dog", @"Cat", @"Dog", @"Cat", @"Dog", @"Cat", @"Llama", @"Goat", @"Lizard"];
    
    for(int i=0; i<malePrefixes.count; ++i) {
        for(int ii=0; ii<maleNames.count; ++ii) {
            [self addNewPetWithName:[NSString stringWithFormat:@"%@%@", malePrefixes[i], maleNames[ii]] andType:animals[i*ii%animals.count] andGender:GenderMale];
        }
    }
    for(int i=0; i<femalePrefixes.count; ++i) {
        for(int ii=0; ii<femaleNames.count; ++ii) {
            [self addNewPetWithName:[NSString stringWithFormat:@"%@%@", femalePrefixes[i], femaleNames[ii]] andType:animals[i*ii%animals.count] andGender:GenderFemale];
        }
    }
    
    return self;
}

- (void)addNewPetWithName:(NSString *)name andType:(NSString *) animalType andGender:(Gender)gender {
    Pet *pet = [[Pet alloc] initWithId:[NSNumber numberWithInt:self.nextPetId++]];
    pet.animalType = animalType;
    pet.name = name;
    pet.gender = gender;
    [_pets setObject:pet forKey:pet.petId];
}

- (NSArray *)getAllPets {
    // simulate a long running process
    [NSThread sleepForTimeInterval:5];
    
    // return one-level-deep copy to avoid mutation complexities and bugs
    return [[NSMutableArray alloc] initWithArray:self.pets.allValues copyItems:YES];
}

- (void)savePet:(nonnull Pet *)pet {
    // simulate a long running process
    [NSThread sleepForTimeInterval:2];
    
    // save copy to avoid code complexity associated with mutable data ("unsaved" data being accessible from getAllPets)
    [self.pets setObject:[pet copy] forKey:pet.petId];
}

@end