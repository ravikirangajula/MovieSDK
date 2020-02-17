//
//  MovieSDKTests.m
//  MovieSDKTests
//
//  Created by Ravikiran Gajula on 16/02/2020.
//  Copyright © 2020 Ravikiran Gajula. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MovMain.h"

@interface MovieSDKTests : XCTestCase
@end

@interface MovMain (Testing)

+(NSArray*)returnTopMostMovies :(NSArray*)totalList;
+(NSArray*)orderTheListbasedOnRating:(NSArray*)array;


@end

@implementation MovieSDKTests

- (void)setUp {
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSDKinitMethod {
     [MovMain initSDK:@""];
}

- (void)testSDKFetchResultsMethodWithEmptyArgument {
    [MovMain setApiKey:@"5540e684dd562fd2be412b9aeda753c0"];
    @try {
        [MovMain getMovieResults:@"" callBackWithResult:^(NSArray * _Nonnull array, NSError * _Nonnull error) {
            XCTFail(@"Expect Exception here");
        }];
    } @catch (NSException *exception) {
        NSLog(@"exception == %@",exception);
        XCTAssertTrue(exception, @"queryString is mandatory");
    } @finally {
        NSLog(@"Finally condition");
    }
   
}

- (void)testSDKFetchResultsMethodWithValidArgument {

    @try {
        [MovMain getMovieResults:@"wewew" callBackWithResult:^(NSArray * _Nonnull array, NSError * _Nonnull error) {
            if (error == nil) {
                XCTAssertTrue(array, @"has array");
            } else {
                XCTAssertTrue(array, @"return error");
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"exception == %@",exception);

           XCTFail(@"Expect callback here");
        
    } @finally {
        NSLog(@"Finally condition");
    }
   
}

-(void)testTopMostMoviesMethod {

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"8.0" forKey:@"vote_average"];
    [dict setValue:@"Bohemian Rhapsody" forKey:@"title"];

    NSMutableDictionary * dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setValue:@"7.0" forKey:@"vote_average"];
    [dict2 setValue:@"Bohemian Rhapsody2" forKey:@"title"];

    NSMutableDictionary * dict3 = [[NSMutableDictionary alloc]init];
    [dict3 setValue:@"8.5" forKey:@"vote_average"];
    [dict3 setValue:@"Bohemian Rhapsody3" forKey:@"title"];

    NSArray * mocArray = [[NSArray alloc]initWithObjects:dict,dict2,dict3, nil];

    NSArray * requiredOutPutArray = [[NSArray alloc]initWithObjects:dict3,dict, nil];

    NSArray * outCome = [MovMain returnTopMostMovies:mocArray];

    XCTAssertEqualObjects(outCome, requiredOutPutArray, @"outCOme movie lsit is top rated list");

}

-(void)testSortedArrayMethod {

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"8.0" forKey:@"vote_average"];
    [dict setValue:@"Bohemian Rhapsody" forKey:@"title"];

    NSMutableDictionary * dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setValue:@"7.0" forKey:@"vote_average"];
    [dict2 setValue:@"Bohemian Rhapsody2" forKey:@"title"];

    NSMutableDictionary * dict3 = [[NSMutableDictionary alloc]init];
    [dict3 setValue:@"8.5" forKey:@"vote_average"];
    [dict3 setValue:@"Bohemian Rhapsody3" forKey:@"title"];

    NSArray * mocArray = [[NSArray alloc]initWithObjects:dict,dict2,dict3, nil];

    NSArray * requiredOutPutArray = [[NSArray alloc]initWithObjects:dict3,dict,dict2, nil];

    NSArray * outCome = [MovMain orderTheListbasedOnRating:mocArray];

    XCTAssertEqualObjects(outCome, requiredOutPutArray, @"noth ar");

}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
