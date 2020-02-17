//
//  MOVMain.h
//  MoviesSDK
//
//  Created by Ravikiran Gajula on 14/02/2020.
//  Copyright © 2020 Ravikiran Gajula. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovMain : NSObject
typedef void (^ReturnMovieList)(NSArray* array, NSError *error);



/// @DIscussion Required to initlise SDK with required parameters
/// @param ApiKey App specific key nee to pass by app
/// @note This is an optional parameter, At this stage htis API also optional
+(void)initSDK:(NSString*)ApiKey;

/// @DIscussion this is Mandatory if API key was not passed in initSDK method
/// @param ApiKey App specifc key need to pass by App before calling getMovieResults API
+(void)setApiKey:(NSString*)ApiKey;

/// @DIscussion API to get Movie results for the year 2017-2018. bases on ratting
/// @param queryString mandatory paramater to pass to sdk to get desired results
/// @param block call back method with sorted list. return error in case of error
/// @note Currently fetching only 2017-2018 released movies  and retunriung if rating is greater tha 8.0
+(void)getMovieResults:(NSString*)queryString callBackWithResult:(ReturnMovieList)block;




@end

NS_ASSUME_NONNULL_END
