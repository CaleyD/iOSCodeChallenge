//
//  ECCreditCard.m
//  Ebay Code Challenge
//

#import <Foundation/Foundation.h>
#import "ECCreditCard.h"

NSString * const VisaIssuer = @"Visa";
NSString * const DiscoverIssuer = @"Discover";
NSString * const AmericanExpressIssuer = @"American Express";
NSString * const MasterCardIssuer = @"MasterCard";
NSString * const UnknownIssuer = @"Unknown";

@interface ECCreditCard ()

@end

bool isBetween(int num, int lowerBound, int upperBound) {
    return num >= lowerBound && num <= upperBound;
}

@implementation ECCreditCard

- (id)initWithNumber:(nonnull NSString*) creditCardNumber {
    if (!(self = [super init])) {
        return nil;
    }
    _number = creditCardNumber;
    
    bool isValidLength;
    _issuer = [self getIssuer:&isValidLength];
    _isValid = isValidLength && [self passesLuhnTest];
    return self;
}

- (BOOL)passesLuhnTest {
    const char * chars = [self.number UTF8String];
    int i=0;
    bool doubleNextDigit = (int)strlen(chars) % 2 == 0;
    int runningSum = 0;
    while(chars[i] != 0) {
        int value = chars[i]-'0';
        if(doubleNextDigit) {
            value = value * 2;
            if(value > 9) {
                value = value - 9;
            }
        }
        runningSum += value;
        ++i;
        doubleNextDigit = !doubleNextDigit;
    }
    return runningSum % 10 == 0;
}

// iin and issuer rules explained at https://en.wikipedia.org/wiki/Payment_card_number#Issuer_identification_number_.28IIN.29
- (NSString *)getIssuer:(bool *)isValidLength {
    int iin = [[self.number stringByAppendingString:@"000000"] substringToIndex:6].intValue;
    int length = (int)self.number.length;
    
    if(isBetween(iin, 400000, 499999)) {
        *isValidLength = length == 16 || length == 13;
        return VisaIssuer;
    }
    if(isBetween(iin, 510000, 559999)) {
        *isValidLength = length == 16;
        return MasterCardIssuer;
    }
    if(isBetween(iin, 370000, 379999) ||
       isBetween(iin, 340000, 349999)) {
        *isValidLength = length == 15;
        return AmericanExpressIssuer;
    }
    if(isBetween(iin, 601100, 601199) ||
       isBetween(iin, 622126, 622925) ||
       isBetween(iin, 644000, 649999) ||
       isBetween(iin, 650000, 659999)) {
        *isValidLength = length == 16 || length == 19;
        return DiscoverIssuer;
    }
    *isValidLength = false;
    return UnknownIssuer;
}

@end