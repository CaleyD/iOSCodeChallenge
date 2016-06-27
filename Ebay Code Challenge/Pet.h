//
//  Pet.h
//  Ebay Code Challenge
//

#ifndef Pet_h
#define Pet_h

typedef enum {
    GenderMale = 1,
    GenderFemale = 2
} Gender;

@interface Pet : NSObject <NSCopying>

- (nullable id)initWithId:(nonnull NSNumber *)petId;

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *animalType;
@property (nonatomic) Gender gender;
@property (nonatomic, strong, nonnull, readonly) NSNumber *petId;

@end

#endif /* Pet_h */
