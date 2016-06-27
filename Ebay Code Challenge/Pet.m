//
//  Pet.m
//  Ebay Code Challenge
//
//  Created by MACINTOSH  on 6/25/16.
//  Copyright © 2016 Caley Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"

@implementation Pet

- (id)initWithId:(NSNumber *)petId {
    if (!(self = [super init])) {
        return nil;
    }
    _petId = petId;
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] initWithId:self.petId];
    
    if (copy) {
        [copy setName:[self.name copyWithZone:zone]];
        [copy setAnimalType:[self.animalType copyWithZone:zone]];
        [copy setGender:self.gender];
    }
    
    return copy;
}

@end