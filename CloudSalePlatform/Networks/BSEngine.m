//
//  BSClient.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BSEngine.h"
#import "Globals.h"
#import "NSStringAdditions.h"

static BSEngine * _currentBSEngine = nil;

@interface BSEngine () {
    
}

@end

@implementation BSEngine

@synthesize user , categoryArray;
@synthesize passWord;
@synthesize deviceIDAPNS;
@synthesize token;

#pragma mark - BSEngine Life Circle
+ (BSEngine *) currentEngine {
    
      @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        if (!_currentBSEngine) {
            _currentBSEngine = [[BSEngine alloc] init];
        }
      }
	return _currentBSEngine;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!_currentBSEngine) {
            _currentBSEngine = [super allocWithZone:zone]; //确保使用同一块内存地址
            return _currentBSEngine;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    
    return self; //确保copy对象也是唯一
    
}



- (id)init {
    if (self = [super init]) {
        [self readAuthorizeData];
    }
    return self;
}

- (void)dealloc {
    self.categoryArray = nil;
//    self.token = nil;
    self.passWord = nil;
    self.deviceIDAPNS = nil;
//    self.user = nil;
}

#pragma mark - BSEngine Private Methods

- (void)saveAuthorizeData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:user];
    if (data && passWord) {
        [defaults setObject:data forKey:KBSCurrentUserInfo];
        [defaults setObject:passWord forKey:KBSCurrentPassword];
        [defaults setObject:token forKey:KBSCurrentToken];
    }
    
	[defaults synchronize];
}

- (void)readAuthorizeData {
    self.user = nil;
    self.passWord = nil;
    self.token = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* data = [defaults objectForKey:KBSCurrentUserInfo];
    NSString* pwd = [defaults objectForKey:KBSCurrentPassword];
    NSString* tok = [defaults objectForKey:KBSCurrentToken];
    if (data && pwd) {
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.passWord = pwd;
        self.token = tok;
    }
}

- (void)deleteAuthorizeData {
    self.user = nil;
    self.passWord = nil;
    
    self.token = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KBSCurrentUserInfo];
    [defaults removeObjectForKey:KBSCurrentPassword];
    [defaults removeObjectForKey:KBSCurrentToken];
    
	[defaults synchronize];
}

- (void)setCurrentUser:(User*)item password:(NSString*)pwd tok:(NSString*)tok{
    if (item) {
        self.user = item;
    }
    if (pwd) {
         self.passWord = pwd;
    }
    if (tok) {
         self.token = tok;
    }
    NSLog(@"保存的登录对象 %@",self);
    NSLog(@"保存的登录token %@",tok);
    
    [self saveAuthorizeData];
}

-(void)setUserIsShowNearShop:(BOOL)isShow{
    [self.user setShowNearShop:isShow];
    
    [self saveAuthorizeData];
}

-(BOOL)userIsShowNearShop{
    return self.user.isShowNearShop;
}

#pragma mark - BSEngine Public Methods

- (void)signOut {
    [self deleteAuthorizeData];
}

#pragma mark Authorization

- (BOOL)isLoggedIn {
//     [self readAuthorizeData];
    return self.token.hasValue;
}

- (BOOL)isNewCard {
    NSUInteger count = self.user.qhtMembers.count + self.user.recommendMembers.count;
    return count == 0;
}
@end
