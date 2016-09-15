//
//  BSEngine.h
//  CloudSalePlatform
//
//  Created by kiwi on 14-1-15.
//  Copyright (c) 2013年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define KBSLoginUserName @"CloudSalePlatformLoginUserName"
#define KBSLoginPassWord @"CloudSalePlatformLoginPassWord"
#define KBSCurrentUserInfo  @"CloudSalePlatformUserInfo"
#define KBSCurrentPassword  @"CloudSalePlatformPassWord"
#define KBSCurrentToken  @"CloudSalePlatformToken"

@interface BSEngine : NSObject {
    
}

@property (nonatomic, strong)   User      *   user;
@property (nonatomic, strong)   NSArray   *   categoryArray; // 行业array
@property (nonatomic, strong)     NSString  *   passWord;
@property (nonatomic, strong)     NSString  *   deviceIDAPNS;
@property (nonatomic, strong)     NSString  *   token; // 用户访问凭证

+ (BSEngine *) currentEngine;
+ (BSEngine *) allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;

- (void)setCurrentUser:(User*)item password:(NSString*)pwd tok:(NSString*)tok;
- (void)readAuthorizeData;

- (void)signOut;
- (BOOL)isLoggedIn;

- (BOOL)isNewCard;

-(void)setUserIsShowNearShop:(BOOL)isShow;
-(BOOL)userIsShowNearShop;
@end
