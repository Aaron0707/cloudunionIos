//
//  StRequest.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "StRequest.h"
#import "Globals.h"

#define KSTRequestTimeOutInterval   30.0
#define KSTRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

@interface StRequest () {
    NSMutableData       * responseData;
}

@property (nonatomic, strong)   NSURLConnection         * connection;
@property (nonatomic, assign)   StRequestPostDataType   postDataType;
@property (nonatomic, strong)   NSString                *    url;
@property (nonatomic, strong)   NSString                *   httpMethod;
@property (nonatomic, strong)   NSDictionary            *    params;
@property (nonatomic, strong)   NSDictionary            *    httpHeaderFields;

@end

@implementation StRequest
@synthesize delegate;
@synthesize postDataType, url, httpMethod, params, httpHeaderFields, connection;

#pragma mark - StRequest Life Circle

- (void)dealloc {
    responseData = nil;
    [connection cancel];
    self.connection = nil;
    self.url = nil;
    self.httpMethod = nil;
    self.params = nil;
    self.httpHeaderFields = nil;
}

#pragma mark - StRequest Private Methods

+ (NSString *)stringFromDictionary:(NSDictionary *)dict {
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString {
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData *)postBody {
    NSMutableData * requestData = [NSMutableData data];
    NSMutableDictionary * strArray = [NSMutableDictionary dictionaryWithDictionary:params];
    __block NSData * data = nil;
    if (postDataType == KSTRequestPostDataTypeNormal) {
        [StRequest appendUTF8Body:requestData dataString:[StRequest stringFromDictionary:params]];
    } else if (postDataType == KSTRequestPostDataTypeMultipart) {
        
        //分界线 --KSTRequestStringBoundary
        NSString *bodyPrefixString = [[NSString alloc]initWithFormat:@"--%@",KSTRequestStringBoundary];
        //结束符 KSTRequestStringBoundary--
        NSString *endbodyboundary = [[NSString alloc]initWithFormat:@"%@--",bodyPrefixString];
        
        //声明结束符：--KSTRequestStringBoundary--
        NSString * end = [[NSString alloc]initWithFormat:@"\r\n%@",endbodyboundary];
        //http body的字符串
        NSMutableString * body = [[NSMutableString alloc]init];
        
        NSMutableData *tempData = [NSMutableData data];
        [strArray enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {;
                //添加分界线，换行
                [body appendFormat:@"%@\r\n",bodyPrefixString];
                //添加字段名称，换2行
                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [body appendFormat:@"%@\r\n",obj];
                [strArray removeObjectForKey:key];
			} else {
                BOOL isImage = [obj isKindOfClass:[UIImage class]];
                NSMutableString * imageBody = [[NSMutableString alloc]init];
                //添加分界线，换行
                [imageBody appendFormat:@"%@\r\n",bodyPrefixString];
                //声明pic字段，文件名为boris.png
                [imageBody appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.%@\"\r\n", key, (isImage?@"jpg":@"mp3")]];
                //声明上传文件的格式
                [imageBody appendString:[NSString stringWithFormat:@"Content-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",isImage?@"image/jpg":@"audio/mp3"]];
                [StRequest appendUTF8Body:tempData dataString:imageBody];
                if (isImage) {
                    [tempData appendData:UIImagePNGRepresentation(obj)];
                } else {
                    [tempData appendData:obj];
                }
                
                [tempData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"imagebody %@",imageBody);
            }
        }];

        [StRequest appendUTF8Body:requestData dataString:body];
        data = [tempData copy];
        if (data) {
            //将多媒体的data加入
            [requestData appendData:data];
        }
        //加入结束符
        [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    }
#if ShouldLogAfterJson
    NSString* strBody =  [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSLog(@"POST BODY (解码后的数据):\r\n%@",[strBody URLDecodedString]);
#endif
    return requestData;
}

- (void)handleResponseData:(NSData *)data {
    if ([delegate respondsToSelector:@selector(request:didReceiveRawData:)]) {
        [delegate request:self didReceiveRawData:data];
    }
	
	NSError* error = nil;
	id result = [self parseJSONData:data error:&error];
    
	if (error) {
        NSString* gotResult =  nil;
        if (gotResult == nil) {
            gotResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (gotResult == nil) {
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            gotResult = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        }
        if (gotResult == nil) {
            gotResult = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        }
        if (gotResult) {
            DLog(@"JSON format Error:\r\n%@",gotResult);
        }
        [self failedWithError:error];
	} else {
        if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
            [delegate request:self didFinishLoadingWithResult:result];
		}
	}
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error {
	NSError *parseError = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
	if (parseError) {
        if (error != nil) {
           *error = [self errorWithCode:KBSErrorCodeSDK
                                userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", KBSSDKErrorCodeParseError]
                                                                     forKey:KBSSDKErrorCodeKey]];
        }
	}
	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:KBSSDKErrorDomain code:code userInfo:userInfo];
    return nil;
}

- (void)failedWithError:(NSError *)error {
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[delegate request:self didFailWithError:error];
	}
}

#pragma mark - BMRequest Public Methods

+ (StRequest *)requestWithURL:(NSString *)url
                   httpMethod:(NSString *)httpMethod
                       params:(NSDictionary *)params
                 postDataType:(StRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id)delegate {
    
    StRequest *request = [[StRequest alloc] init];
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.postDataType = postDataType;
    request.httpHeaderFields = httpHeaderFields;
    request.delegate = delegate;
    
    return request;
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod {
    if (![httpMethod isEqualToString:@"GET"]) {
        return baseURL;
    }
    //    NSURL * parsedURL = [NSURL URLWithString:baseURL];
	NSString * queryPrefix = @"&";
	NSString * query = [StRequest stringFromDictionary:params];
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

- (void)connect {
    NSString *urlString = [StRequest serializeURL:url params:params httpMethod:httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:KSTRequestTimeOutInterval];
    [request setHTTPMethod:httpMethod];
#if ShouldLogAfterRequest
    DLog(@"URL : %@", urlString);
#endif
    if ([httpMethod isEqualToString:@"POST"]) {
        if (postDataType == KSTRequestPostDataTypeMultipart) {
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", KSTRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        NSData* postBody = [self postBody];
        
        NSTimeInterval timeinterval = KSTRequestTimeOutInterval + ([postBody length]>>14);
//        DLog(@"超时时间 : %.2f s \nPost Body Length : %d bytes",timeinterval,[postBody length]);
        
        [request setTimeoutInterval:timeinterval];
        [request setHTTPBody:postBody];
    }
    
    for (NSString *key in [httpHeaderFields keyEnumerator]) {
        [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


- (void)disconnect {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    delegate = nil;
    responseData = nil;
    [connection cancel];
    connection = nil;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseData = [[NSMutableData alloc] init];
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#if ShouldLogAfterRequest == 1
    NSString* gotResult =  nil;
    if (gotResult == nil) {
        gotResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    if (gotResult == nil) {
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        gotResult = [[NSString alloc] initWithData:responseData encoding:gbkEncoding];
    }
    if (gotResult == nil) {
        gotResult = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    }
    DLog(@"connectionDidFinishLoading\r\n%@",gotResult);
#endif
    
	[self handleResponseData:responseData];
    responseData = nil;
    
    [connection cancel];
    connection = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self failedWithError:error];
    responseData = nil;
    [connection cancel];
    connection = nil;
}

@end
