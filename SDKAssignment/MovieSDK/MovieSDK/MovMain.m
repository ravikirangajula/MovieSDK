//
//  MOVMain.m
//  MoviesSDK
//
//  Created by Ravikiran Gajula on 14/02/2020.
//  Copyright © 2020 Ravikiran Gajula. All rights reserved.
//

#import "MovMain.h"

#define baseUrl @"https://api.themoviedb.org/3/discover/movie?api_key="


NSString * keyFromAPP;

@implementation MovMain {
    
}

- (instancetype)init {
    if (self = [super init]) {
        // Initialize self
    }
    return self;
}

+(void)initSDK:(NSString*)ApiKey {
    NSLog(@"SDK , Initlised with AppKey == %@", ApiKey);
    keyFromAPP = ApiKey;
}

+(void)setApiKey:(NSString*)ApiKey {
    
    if (ApiKey == nil || ApiKey.length <= 0) {
        NSException * myException = [[NSException alloc]initWithName:@"MoviesSDK:" reason:@"APIKey Should not be empty" userInfo:nil];
        @throw myException;
    }
    keyFromAPP = ApiKey;
}

///@Note here i have not find any API to give result between the year 2017-2018 . so i made two API calls . not invested much time in checking for API s . jsut used query string and based on that returning results
///Mainly focused on SDK . if i get proper APIs with proper data i will do
///One more problem here is if call this api it will give movie list for page 1 if i want all pages i need to call same api with page 2 as parameter .so not called
/// Jsut simplield demosnstarte that i can develop frameworks

+(void)getMovieResults:(NSString*)queryString callBackWithResult:(ReturnMovieList)block {
    
    if (keyFromAPP == nil || keyFromAPP.length <= 0) {
        NSException * myException = [[NSException alloc]initWithName:@"MoviesSDK:" reason:@"APIKey Should not be empty" userInfo:nil];
        @throw myException;
    }
    
    if (queryString == nil || queryString.length <= 0) {
        
        NSException * myException = [[NSException alloc]initWithName:@"MoviesSDK:" reason:@"queryString is mandatory" userInfo:nil];
        @throw myException;
    }
    
    NSString * str1 = [NSString stringWithFormat:@"%@%@&sort_by=popularity.desc&include_adult=false&include_video=false&primary_release_year=2017&query=%@",baseUrl,keyFromAPP,queryString];
    NSString * str2 = [NSString stringWithFormat:@"%@%@&sort_by=popularity.desc&include_adult=false&include_video=false&primary_release_year=2018&query=%@",baseUrl,keyFromAPP,queryString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:str1];
    NSURL *url2 = [NSURL URLWithString:str2];
    NSLog(@"str1== %@",str1);
    NSLog(@"str2== %@",str2);
    
    NSURLSessionDataTask *task1 = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * dict2017 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray * resultArray2017 = [dict2017 valueForKey:@"results"];
        NSLog(@"resultArray2017== %@",resultArray2017);
        
        NSURLSessionDataTask *task2 = [session dataTaskWithURL:url2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary * dict2018 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray * resultArray2018 = [dict2018 valueForKey:@"results"];
            if (error == nil) {
                block( [self returnTopMostMovies:[resultArray2017 arrayByAddingObjectsFromArray:resultArray2018]], error);
            } else {
                block(resultArray2017, error);
            }
        }];
        
        [task2 resume];
    }];
    [task1 resume];
}

///@Discussion Method to return top rated movies based on vote_average
///@note here i am considering ratiing whcih is above or equal to 7.5.
///When i query with top rated paramter APIs giving movie list which is less than 2 also so from SDK side hardcoded to 7.5. I get Proper APIs i can handle more simplest way
+(NSArray*)returnTopMostMovies :(NSArray*)totalList  {
    
    NSMutableArray * topArray = [[NSMutableArray alloc]init];
    for (NSDictionary *obj in totalList) {
        double rating = [[obj valueForKey:@"vote_average"] doubleValue];
        if ((rating >= 7.5) && [topArray count] <= 9){
            [topArray addObject:obj];
        }
    }
    return [self orderTheListbasedOnRating:topArray];
}

+(NSArray*)orderTheListbasedOnRating:(NSArray*)array {
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"vote_average" ascending:NO]]];
    return sortedArray;
}

@end
