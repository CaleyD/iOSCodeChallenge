//
//  ECCreditCardTests.m
//  Ebay Code Challenge
//

#import "ECCreditCard.h"
#import <XCTest/XCTest.h>

@interface ECCreditCardTests : XCTestCase

@end

NSString *getIssuer(NSString *creditCardNumber) {
    return [[ECCreditCard alloc] initWithNumber:creditCardNumber].issuer;
}
bool getIsValid(NSString *creditCardNumber) {
    return [[ECCreditCard alloc] initWithNumber:creditCardNumber].isValid;
}


@implementation ECCreditCardTests

// NOTE: I typically use Given/When/Then syntax in tests but with the simplicity of this class's interface, it makes the tests too verbose and more difficult to understand.

- (void)testShouldInitializeCreditCardNumberProperty {
    XCTAssertEqual([[ECCreditCard alloc] initWithNumber:@"1234"].number, @"1234");
    XCTAssertEqual([[ECCreditCard alloc] initWithNumber:@"123456"].number, @"123456");
}

- (void)testShouldReturnUnknownIssuerAndInvalidForUnrecognizedIssuers {
    XCTAssertEqual(getIssuer(@"1234653312341234"), UnknownIssuer);
    XCTAssertFalse(getIsValid(@"1234653312341234"));
    
    XCTAssertEqual(getIssuer(@"AAAA653312341234"), UnknownIssuer);
    XCTAssertFalse(getIsValid(@"AAAA653312341234"));

    XCTAssertEqual(getIssuer(@"0000111122223333"), UnknownIssuer);
    XCTAssertFalse(getIsValid(@"0000111122223333"));
}

- (void)testShouldSetIssuerVisaWhenFirstDigitIs4 {
    XCTAssertEqual(getIssuer(@"4000000000000000"), VisaIssuer);
    XCTAssertEqual(getIssuer(@"400"), VisaIssuer);
}

- (void)testShouldBeValidForVisaWithGoodLuhnAndLength13or16 {
    XCTAssertTrue(getIsValid(@"4111111111111111"));
    XCTAssertTrue(getIsValid(@"4012888888881881"));
    XCTAssertTrue(getIsValid(@"4222222222222"));
    
    // negative tests
    XCTAssertFalse(getIsValid(@"40600"), @"Good Luhn, bad length");
    XCTAssertFalse(getIsValid(@"4001111000000000"), @"Good length, bad Luhn");
}

- (void)testShouldSetIssuerMasterCardWhenFirstDigitsAre51through55 {
    XCTAssertEqual(getIssuer(@"5100000000000000"), MasterCardIssuer);
    XCTAssertEqual(getIssuer(@"520000000000000"), MasterCardIssuer);
    XCTAssertEqual(getIssuer(@"53000000000000"), MasterCardIssuer);
    XCTAssertEqual(getIssuer(@"5400000000000"), MasterCardIssuer);
    XCTAssertEqual(getIssuer(@"550000000000"), MasterCardIssuer);

    // negative tests
    XCTAssertEqual(getIssuer(@"500000000000000"), UnknownIssuer);
    XCTAssertEqual(getIssuer(@"56000000000000000"), UnknownIssuer);
}

- (void)testShouldBeValidForMasterCardWithGoodLuhnAndLength16 {
    XCTAssertTrue(getIsValid(@"5555555555554444"));
    XCTAssertTrue(getIsValid(@"5105105105105100"));
    
    // negative tests
    XCTAssertFalse(getIsValid(@"51051051051051"), @"Good Luhn, bad length");
    XCTAssertFalse(getIsValid(@"51999999999999999"), @"Good length, bad Luhn");
}

- (void)testShouldSetIssueAmericanExpressWhenFirstDigitsAre34or37 {
    XCTAssertEqual(getIssuer(@"34"), AmericanExpressIssuer);
    XCTAssertEqual(getIssuer(@"37000000000"), AmericanExpressIssuer);
}

- (void)testShouldBeValidForAmericanExpressWithGoodLuhnAndLength15 {
    XCTAssertTrue(getIsValid(@"378282246310005"));
    XCTAssertTrue(getIsValid(@"371449635398431"));
    
    // negative tests
    XCTAssertFalse(getIsValid(@"3782822463105"), @"Good Luhn, bad length");
    XCTAssertFalse(getIsValid(@"370000000000000"), @"Good length, bad Luhn");
}

- (void)testShouldSetIssuerDiscoveryForVariousPrefixes {
    // 6011
    XCTAssertEqual(getIssuer(@"6011000000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6011000000000000000"), DiscoverIssuer);
    
    //622126-622925
    XCTAssertEqual(getIssuer(@"6221260000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6225550000000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6228880000000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6229250000000000000"), DiscoverIssuer);
    
    //644-649
    XCTAssertEqual(getIssuer(@"644000000000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6460000000000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6490000000000000000"), DiscoverIssuer);
    
    //65
    XCTAssertEqual(getIssuer(@"650000000000000000"), DiscoverIssuer);
    XCTAssertEqual(getIssuer(@"6500000000000000000"), DiscoverIssuer);
    
    // negative tests
    XCTAssertEqual(getIssuer(@"6600000000000000000"), UnknownIssuer);
    XCTAssertEqual(getIssuer(@"6221250000000000000"), UnknownIssuer);
    XCTAssertEqual(getIssuer(@"6229260000000000000"), UnknownIssuer);
    XCTAssertEqual(getIssuer(@"6012000000000000000"), UnknownIssuer);
    XCTAssertEqual(getIssuer(@"6430000000000000000"), UnknownIssuer);
}

- (void)testShouldBeValidForDiscoverWithGoodLuhnAndLength16or19 {
    XCTAssertTrue(getIsValid(@"6011111111111117"));
    XCTAssertTrue(getIsValid(@"6011000990139424"));
    
    // negative tests
    XCTAssertFalse(getIsValid(@"60111111111117"), @"Good Luhn, bad length");
    XCTAssertFalse(getIsValid(@"6011111111111118"), @"Good length, bad Luhn");
}

@end