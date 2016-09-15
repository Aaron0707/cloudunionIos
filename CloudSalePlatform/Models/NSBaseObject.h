//
//  NSBaseObject.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"

@interface NSBaseObject : NSObject {
    BOOL isInitSuccuss;
}

@property (nonatomic,strong) NSString * badge;

+ (id)objWithJsonDic:(NSDictionary*)dic;
- (id)initWithJsonDic:(NSDictionary*)dic;
- (void)updateWithJsonDic:(NSDictionary*)dic;

@end
