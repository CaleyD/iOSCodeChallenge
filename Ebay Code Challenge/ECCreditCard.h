//
//  ECCreditCard.h
//  Ebay Code Challenge
//

#ifndef ECCreditCard_h
#define ECCreditCard_h
#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * __nonnull const VisaIssuer;
FOUNDATION_EXPORT NSString * __nonnull const DiscoverIssuer;
FOUNDATION_EXPORT NSString * __nonnull const AmericanExpressIssuer;
FOUNDATION_EXPORT NSString * __nonnull const MasterCardIssuer;
FOUNDATION_EXPORT NSString * __nonnull const UnknownIssuer;

@interface ECCreditCard : NSObject

// This code assumes another layer/tier takes care of formatting (removing all non-numeric characters)
// because it wasn't explicitly called out in the isntructions, otherwise we'd normalize the number first.
- (nullable id)initWithNumber:(nonnull NSString *) creditCardNumber;

@property (nonatomic, readonly, nonnull) NSString * number;
@property (nonatomic, readonly) BOOL isValid;
// Note - this is NSString b/c instructions had quotes around "Unknown"
@property (nonatomic, readonly, nonnull) NSString * issuer;

@end

#endif /* ECCreditCard_h */
