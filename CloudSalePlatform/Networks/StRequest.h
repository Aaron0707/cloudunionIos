//
//  StRequest.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    KSTRequestPostDataTypeNone,
	KSTRequestPostDataTypeNormal,			// for normal data post, such as "user=name&password=psd"
	KSTRequestPostDataTypeMultipart,        // for uploading images and files.
}StRequestPostDataType;

@class StRequest;

@protocol StRequestDelegate <NSObject>
@optional
- (void)request:(StRequest*)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(StRequest*)request didReceiveRawData:(NSData *)data;
- (void)request:(StRequest*)request didFailWithError:(NSError *)error;
- (void)request:(StRequest*)request didFinishLoadingWithResult:(id)result;
@end

@interface StRequest : NSObject

@property (nonatomic, strong) id <StRequestDelegate> delegate;

+ (StRequest *)requestWithURL:(NSString *)url
                   httpMethod:(NSString *)httpMethod
                       params:(NSDictionary *)params
                 postDataType:(StRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<StRequestDelegate>)delegate;

- (void)connect;
- (void)disconnect;

@end
