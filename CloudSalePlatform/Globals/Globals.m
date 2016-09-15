//
//  Globals.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Globals.h"
#import "User.h"
#import "Declare.h"
#import <CoreLocation/CoreLocation.h>

@implementation Globals

+ (UIColor*)getColorViewBkg {
    return tabColor;
}

+ (UIColor*)getColorGrayLine {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg_gray_line"]];
}

+ (UIImage*)getImageInputViewBkg {
    return [[UIImage imageNamed:bkgNameOfInputView] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
}

+ (UIImage*)getImageUserHeadDefault {
    return [UIImage imageNamed:@"defaultHeadImage"];
}

+ (UIImage*)getImageDefault {
    return [UIImage imageNamed:@"defaultImage"];
}

+ (UIImage*)getImageGray {
    return [[UIImage imageNamed:@"bkg_gray_line"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
}

+ (UIImage *)getImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString*)timeStringWith:(NSTimeInterval)timestamp {
    NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, timestamp);
    if (distance < 0) distance = 0;
    
    if (distance < 10) {
        _timestamp = [NSString stringWithFormat:@"刚刚"];
    } else if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"秒前"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"分钟前"];
    } else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"小时前"];
    } else if (distance < 60 * 60 * 24 * 4) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    } else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd hh:mm"];
//            [dateFormatter setDateFormat:@"MM-dd hh:mm"];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)convertDateFromString:(NSString*)uiDate timeType:(int)timeType
{
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:uiDate.doubleValue/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (timeType == 0) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else if (timeType == 1){
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    } else if (timeType == 2){
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (timeType == 3){
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    }
    NSString *strDate = [dateFormatter stringFromDate:data];
    return strDate;
}

+ (NSString*)errorDetailWithCode:(int)code {
    NSString * err_c = [NSString stringWithFormat:@"ErrorCode%d", code];
    NSString * res = NSLocalizedString(err_c, nil);
    if ([res isEqualToString:err_c]) {
        res = @"未知错误";
    }
    return res;
}

+ (void)initializeGlobals {
    NSFileManager * fMan = [NSFileManager defaultManager];
    NSString * new_path_b = [NSString stringWithFormat:@"%@/Library/Cache",NSHomeDirectory()];
    NSString * new_path = [NSString stringWithFormat:@"%@/Library/Cache/Images",NSHomeDirectory()];
    NSString * new_path_person = [NSString stringWithFormat:@"%@/Library/Cache/Person",NSHomeDirectory()];
    NSString * new_path_a = [NSString stringWithFormat:@"%@/Library/Cache/Audios",NSHomeDirectory()];
    if ((![fMan fileExistsAtPath:new_path_b]) || (![fMan fileExistsAtPath:new_path])) {
        [fMan createDirectoryAtPath:new_path_b withIntermediateDirectories:YES attributes:nil error:nil];
        [fMan createDirectoryAtPath:new_path withIntermediateDirectories:YES attributes:nil error:nil];
        [fMan createDirectoryAtPath:new_path_person withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fMan fileExistsAtPath:new_path_a]) {
        [fMan createDirectoryAtPath:new_path_a withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString*)timeString {
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
}

+ (void)imageDownload:(Img_Block)block url:(NSString*)url {
    if (url && url.length > KBSSDKAPIURL.length) {
        dispatch_async(kQueueDEFAULT, ^{
            @autoreleasepool {
                NSString * path = [NSString stringWithFormat:@"%@/Library/Cache/Images/%@.dat",NSHomeDirectory(),[url md5Hex]];
                NSData * data = [NSData dataWithContentsOfFile:path];
                if (!data) {
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    [data writeToFile:path atomically:YES];
                }
                dispatch_async(kQueueMain, ^{
                    UIImage *img = [UIImage imageWithData:data];
                    block(img);
                });
            }
        });
    } else {
        block([Globals getImageDefault]);
    }
}

+ (NSString*)sendTimeString:(double)sendTime {
    NSString * _timestamp;
    NSTimeInterval timestamp = sendTime/ 1000;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, timestamp);
    if (distance < 0) distance = 0;
    
    if (distance < 10) {
        _timestamp = [NSString stringWithFormat:@"刚刚"];
    } else if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"秒前"];
    } else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"分钟前"];
    } else if (distance < 60 * 60 * 24) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日 hh:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        _timestamp = [dateFormatter stringFromDate:date];
    } else if (distance < 60 * 60 * 24 * 30) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日 hh:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        _timestamp = [dateFormatter stringFromDate:date];
    } else {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-M-d hh:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    
    return _timestamp;
}

Location kLocationMake(double la, double ln) {
    Location res;
    res.lat = la;
    res.lng = ln;
    return res;
}

+ (void)callAction:(NSString *)phone parentView:(UIView*)view {
    NSString * num = [NSString stringWithFormat:@"tel:%@", phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:num];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [view addSubview:callWebview];
}

+ (NSMutableArray *)sortdata:(NSArray*)tempArray
{
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (NSMutableDictionary *city in tempArray) {
        NSInteger sect = 0;
        sect = [theCollation sectionForObject:city
                      collationStringSelector:@selector(getNameValue)];
        [city setObject:[NSString stringWithFormat:@"%ld", (long)sect] forKey:@"spell"];
    }
    NSMutableArray *newSectionsArray = [NSMutableArray array];
    
    // 27个索引
	for (int index = 0; index < 27; index++) {
		NSMutableArray *array = [NSMutableArray array];
		[newSectionsArray addObject:array];
	}
    
	for (NSMutableDictionary *city in tempArray) {
        //获得section的数组
		NSMutableArray *sectionName = [newSectionsArray objectAtIndex:[[city getStringValueForKey:@"spell" defaultValue:@""] intValue]];
        //添加到section中
		[sectionName addObject:city];
	}
    
    return newSectionsArray;
}

+ (double)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2 {
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}

+(BOOL)isPhoneNumber:(NSString *)phone{
//    NSString *Regex =@"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}";
//    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//    return [mobileTest evaluateWithObject:phone];
    
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * MOBILE = @"^1\\d{10}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
//     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if ([regextestmobile evaluateWithObject:phone] == YES)
//        || ([regextestcm evaluateWithObject:phone] == YES)
//        || ([regextestct evaluateWithObject:phone] == YES)
//        || ([regextestcu evaluateWithObject:phone] == YES)
//        || ([regextestphs evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSString *)getMyUUID{
    NSString *uuidStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CLOUDVASTUUID"]];
    if (!uuidStr.hasValue) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
        // 就下面这个玩意
        NSString *identifierNumber = [NSString stringWithFormat:@"%@",uuidstring];
        // 存起来以后用
        [[NSUserDefaults standardUserDefaults] setObject:identifierNumber forKey:@"CLOUDVASTUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidstring);
        CFRelease(uuid);
        uuidStr = identifierNumber;
    }
    return uuidStr;
}
@end
