//
//  PetStore.h
//  Ebay Code Challenge
//

#import "Pet.h"

#ifndef PetStore_h
#define PetStore_h

@interface PetStore : NSObject

- (nullable id)init;
- (nonnull NSArray *) getAllPets;
- (void) savePet:(nonnull Pet *)pet;
- (nonnull NSArray *) getAvailableAnimalTypes;

@end

#endif /* PetStore_h */
