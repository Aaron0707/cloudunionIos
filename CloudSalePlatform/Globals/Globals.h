//
//  Globals.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>

// net work
#define ShouldLogAfterRequest   1
#define ShouldLogAfterJson      1
#define ShouldLogXMPPDebugInfo  0

#define DB_Version @"1.0.0"
#define defaultSizeInt 20

#define KBSSDKErrorDomain           @"CarPoolSDKErrorDomain"
#define KBSSDKErrorCodeKey          @"CarPoolSDKErrorCodeKey"
#define AboutPage [NSString stringWithFormat:@"http://api.cloudvast.com/cus/about.htm?token=%@", [BSEngine currentEngine].token]         // 关于页面
#define AgreementPage [NSString stringWithFormat:@"http://api.cloudvast.com/cus/agreement.htm?token=%@", [BSEngine currentEngine].token] // 用户协议
#define UMShareKey @"54606d00fd98c5342d003bca" //53c7927056240bd35e026918 微信好友，微信朋友圈，QQ好友，QQ空间，微博，短信
#define UMShareMessage @"我正在使用云购平台购买好东西！" // 微信好友，微信朋友圈，QQ好友，QQ空间，微博，短信

typedef enum
{
	KBSErrorCodeInterface	= 100,
	KBSErrorCodeSDK         = 101,
}LFErrorCode;

typedef enum
{
	KBSSDKErrorCodeParseError       = 200,
	KBSSDKErrorCodeRequestError     = 201,
	KBSSDKErrorCodeAccessError      = 202,
	KBSSDKErrorCodeAuthorizeError	= 203,
}LFSDKErrorCode;

typedef void (^Img_Block)(UIImage *img);
// data
#define NUMBERS @"0123456789\n"
#define LETTERS @"abcdefghijklmnopqrstuvwxvz\n"
#define SIZE_FONT16 16
#define SIZE_FONT15 15
#define SIZE_FONT14 14
#define SIZE_FONT13 13
#define SIZE_FONT12 12
#define SIZE_FONT10 10
#define kCornerRadiusNormal     5.0
#define kCornerRadiusSmall      4.0
#define bkgNameOfView           @"bkg_view"
#define bkgNameOfInputView      @"bkg_input"

@interface Globals : NSObject

+ (UIColor*)getColorViewBkg;
+ (UIColor*)getColorGrayLine;
+ (UIImage*)getImageInputViewBkg;
+ (UIImage*)getImageDefault;
+ (UIImage*)getImageUserHeadDefault;
+ (UIImage*)getImageGray;
+ (UIImage *)getImageWithColor:(UIColor*)color;

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString*)convertDateFromString:(NSString*)uiDate timeType:(int)timeType;
+ (NSString*)timeStringWith:(NSTimeInterval)timestamp;
+ (NSString*)errorDetailWithCode:(int)code;

+ (void)initializeGlobals;

+ (NSString*)timeString;
+ (void)imageDownload:(Img_Block)block url:(NSString*)url;

+ (NSString*)sendTimeString:(double)sendTime;
+ (void)callAction:(NSString *)phone parentView:(UIView*)view;
+ (NSMutableArray *)sortdata:(NSArray*)tempArray;
+ (double)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2;

+ (BOOL)isPhoneNumber:(NSString *)phone;
+(NSString *)getMyUUID;
@end
