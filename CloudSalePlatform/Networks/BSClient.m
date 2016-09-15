//
//  BSClient.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BSClient.h"
#import "BSEngine.h"
#import "StRequest.h"
#import "KAlertView.h"
#import "NSDictionaryAdditions.h"
#import "JSON.h"
#import "CricleComment.h"
#import "AddressItem.h"

#import "KWAlertView.h"

@interface BSClient () <StRequestDelegate> {
    BOOL    needUID;
    BOOL    cancelled;
}

@property (nonatomic, assign)   id          delegate;
@property (nonatomic, assign)   SEL         action;
@property (nonatomic, strong)   StRequest   *   bsRequest;
@property (nonatomic, weak)     BSEngine    *   engine;

@end

@implementation BSClient
@synthesize action;
@synthesize bsRequest;
@synthesize engine;
@synthesize errorMessage;
@synthesize hasError;
@synthesize indexPath;
@synthesize customErrorCode;
@synthesize tag;
@synthesize delegate;

- (id)initWithDelegate:(id)del action:(SEL)act {
    self = [super init];
    if (self) {
        self.delegate = del;
        self.action = act;
        
        needUID = YES;
        self.hasError = YES;
        self.engine = [BSEngine currentEngine];
    }
    return self;
}

- (void)dealloc {
    Release(tag);
    Release(indexPath);
    Release(errorMessage);
    Release(action);
    Release(bsRequest);
    Release(engine);
    self.delegate = nil;
}

- (void)cancel {
    if (!cancelled) {
        [bsRequest disconnect];
        self.bsRequest = nil;
        cancelled = YES;
        self.action = nil;
        self.delegate = nil;
    }
}

- (void)showAlert {
    NSString* alertMsg = nil;
    if ([errorMessage isKindOfClass:[NSString class]] && errorMessage.length > 0) {
        alertMsg = errorMessage;
    } else {
        alertMsg = @"服务器出去晃悠了，等它一下吧！";
    }
    //    [KAlertView showType:KAlertTypeError text:alertMsg for:0.8 animated:YES];
    KWAlertView * alert = [[KWAlertView alloc] initWithTitle:@"提示" message:alertMsg delegate:nil cancelButtonTitle:@"确定" textViews:nil otherButtonTitles: nil];
    [alert show];
}

- (void)loadRequestWithDoMain:(BOOL)isDoMain
                   methodName:(NSString *)methodName
                       params:(NSMutableDictionary *)params
                 postDataType:(StRequestPostDataType)postDataType {
    [bsRequest disconnect];
    
    NSMutableDictionary* mutParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (needUID) {
        if (engine.token) {
            [mutParams setObject:engine.token forKey:@"token"];
        }
    }
    
    self.bsRequest = [StRequest requestWithURL:[NSString stringWithFormat:@"%@%@", KBSSDKAPIDomain, methodName]
                                    httpMethod:@"POST"
                                        params:mutParams
                                  postDataType:postDataType
                              httpHeaderFields:nil
                                      delegate:self];
    [bsRequest connect];
}

#pragma mark - StRequestDelegate Methods

- (void)request:(StRequest*)sender didFailWithError:(NSError *)error {
    if (cancelled) {
        return;
    }
    
    NSString * errorStr = [[error userInfo] objectForKey:@"error"];
    if (errorStr == nil || errorStr.length <= 0) {
        errorStr = [NSString stringWithFormat:@"%@", [error localizedDescription]];
    } else {
        errorStr = [NSString stringWithFormat:@"%@", [[error userInfo] objectForKey:@"error"]];
    }
    self.errorMessage = errorStr;
    NSLog(@"errorStr -======== %@",errorStr);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (action && delegate) {
        [delegate performSelector:action withObject:self withObject:error];
    }
#pragma clang diagnostic pop
    self.bsRequest = nil;
}

-(void)request:(StRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    switch ([httpResponse statusCode]) {
        case 404:
            [self cancel];
            self.hasError = YES;
            self.errorMessage = @"访问连接错误！！";
            [self showAlert];
            break;
        case 500:
            [self cancel];
            self.hasError = YES;
            self.errorMessage = @"服务器内部错误！！";
            [self showAlert];
            break;
        default:
            break;
    }
}

- (void)request:(StRequest*)sender didFinishLoadingWithResult:(NSDictionary*)result {
    if (cancelled) {
        return;
    }
    
    BOOL state = NO;
    if (result != nil && [result isKindOfClass:[NSDictionary class]]) {
        state = [result getBoolValueForKey:@"success" defaultValue:NO];
        NSString * expired = [result getStringValueForKey:@"expired" defaultValue:@""];
        if (expired && [@"expired" isEqualToString:expired]) {
            self.isOldToken = YES;
        }
        self.hasError = !state;
        self.customErrorCode = state;
        if (!state) {
            self.errorMessage = [result getStringValueForKey:@"msg" defaultValue:nil];
        }
    }
    
    if (!state && self.errorMessage == nil) {
        self.errorMessage = @"让网络飞一会再说吧..";
    }
    
    self.bsRequest = nil;
    if (cancelled) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate performSelector:action withObject:self withObject:result];
#pragma clang diagnostic pop
    
}

#pragma mark - Method

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	登陆
 *
 *	@param username: (字符串) (登录用户名，一般都是云联卡持卡人的手机号)
 *	@param password：（字符串） （云联卡密码）
 *	@param devicePlatform: (字符串)  (设备系统名称，可选值：ANDROID/IOS)
 *	@param platformVersion: (字符串)  (设备系统版本号)
 *	@param appVersion: (字符串)  (APP版本号)
 */
- (void)loginWithUserPhone:(NSString *)phone
                  password:(NSString *)pwd {
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"username"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:pwd forKey:@"password"];
    
    [params setObject:@"IOS" forKey:@"platform"];
    [params setObject:[NSString stringWithFormat:@"%@:%f", Sys_Name, Sys_Version] forKey:@"platformVersion"];
    NSString * ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    [params setObject:ver forKey:@"appVersion"];
    [self loadRequestWithDoMain:YES
                     methodName:@"passport/login.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	注销登录
 *
 */
- (void)logout {
    [self loadRequestWithDoMain:YES
                     methodName:@"passport/logout.htm"
                         params:nil
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	用户详细资料
 *
 */
- (void)MyInfo {
    [self loadRequestWithDoMain:YES
                     methodName:@"user/info.htm"
                         params:nil
                   postDataType:KSTRequestPostDataTypeNormal];
    //    [self loadRequestWithDoMain:YES
    //                     methodName:@"passport/findProfile.htm"
    //                         params:nil
    //                   postDataType:KSTRequestPostDataTypeNormal];
}

- (void)findProFileByPhone:(NSString *)phone{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (phone.hasValue) {
        [params setObject:phone forKey:@"phone"];
    }else{
        return;
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"passport/findProfile.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	修改头像
 *
 *	@param 	head 	头像
 */
- (void)editAvatar:(UIImage*)head {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:head forKey:@"avatar"];
    [self loadRequestWithDoMain:YES
                     methodName:@"user/editAvatar.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeMultipart];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	会员账户详情
 *
 *	@param 	memberId 	会员id
 */
- (void)memberDetail:(NSString*)memberId {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:memberId forKey:@"memberId"];
    [self loadRequestWithDoMain:YES
                     methodName:@"user/memberDetail.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	首页轮播图片
 *
 */
- (void)gallery {
    [self loadRequestWithDoMain:YES
                     methodName:@"home/gallery.htm"
                         params:nil
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= 获取城市列表 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	城市查询接口
 *	@param query 关键字<可选>
 *
 */
- (void)findCityIfNeedKey:(NSString*)key {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (key) {
        [params setObject:key forKey:@"query"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:@"common/findCity.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findCitysByProvinceCode:(NSString *)code query:(NSString *)query{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (query.hasValue) {
        [params setObject:query forKey:@"query"];
    }
    
    if (code.hasValue) {
        [params setObject:code forKey:@"provinceCode"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:@"common/findCities.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *获取省份
 */
-(void)findProvinces:(NSString *)key{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (key) {
        [params setObject:key forKey:@"query"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:@"common/findProvinces.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	查找目标城市所有商圈
 *
 *	@param 	cityCode 	城市编号
 */
- (void)findDistrict:(NSString*)cityCode {
    [self loadRequestWithDoMain:YES
                     methodName:@"common/findDistrict.htm"
                         params:[NSMutableDictionary dictionaryWithObject:cityCode forKey:@"cityCode"]
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= 商家 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	附近商家
 *
 *	@param 	businessCategoryId 	行业id
 *	@param 	latitude 	纬度
 *	@param 	longitude 	经度
 */
- (void)nearbyShop:(NSString*)businessCategoryId latitude:(NSString*)latitude longitude:(NSString*)longitude page:(int)page {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (businessCategoryId) {
        [params setObject:businessCategoryId forKey:@"businessCategoryId"];
    }
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longitude forKey:@"longitude"];
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findNearbyShop.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	关键字搜索商家
 *
 *	@param 	businessCategoryId 	行业id<可选>
 *	@param 	districtCode 	商圈编号<可选>
 *	@param  cityCode 城市编号
 *	@param 	query 	搜索关键字<可选>
 */
- (void)searchShop:(NSString*)businessCategoryId
      districtCode:(NSString*)districtCode
          cityCode:(NSString*)cityCode
             query:(NSString*)query
              page:(int)page
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (businessCategoryId && businessCategoryId.intValue >=0) {
        [params setObject:businessCategoryId forKey:@"businessCategoryId"];
    }
    if (!districtCode) {
        districtCode = cityCode;
    }
    [params setObject:districtCode forKey:@"districtCode"];
    [params setObject:cityCode forKey:@"cityCode"];
    if (query) {
        [params setObject:query forKey:@"query"];
    }
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/searchShop.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	商家详情
 *
 *	@param 	shopId 	商家ID
 *	@param 	page    (页码) <可选, 默认为1>
 *
 *  @return shop:  {}商家信息
 wares: [] 商品或服务项目的列表
 pager: 商品分页信息
 description: 商家描述
 phone: 商家电话
 */
- (void)findShopDetailWithID:(NSString*)shopId page:(int)page {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:shopId forKey:@"shopId"];
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findShopDetail.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}


/**
 *
 *
 *	获取登录用户的店铺
 *
 *	@param 	wareId 	商品或服务项目ID
 *
 *  @return 商品或服务详情
 */
-(void)findOpenShop{
    [self findOpenShop:nil];
}
- (void)findOpenShop:(NSString *)shopId {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (shopId && shopId.length>0) {
        [params setObject:shopId forKey:@"shopId"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"user/findOpenShop.htm"
                         params:params.count>0?params:nil
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	商品、服务项目详情
 *
 *	@param 	wareId 	商品或服务项目ID
 *
 *  @return 商品或服务详情
 */
- (void)findWareWithId:(NSString*)wareId {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:wareId forKey:@"id"];
    [self loadRequestWithDoMain:YES
                     methodName:@"micronet/findWareById.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

- (void)findwareWithCategoryId:(NSString *)categoryId shopId:(NSString *)shopId query:(NSString *)query page:(int)p{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (categoryId.hasValue) {
        [params setObject:categoryId forKey:@"catId"];
    }
    if (shopId.hasValue) {
        [params setObject:shopId forKey:@"orgId"];
    }
    if (query.hasValue) {
        [params setObject:query forKey:@"query"];
    }
    if (p>1) {
        [params setObject:[NSString stringWithFormat:@"%i",p] forKey:@"p"];
    }
    [params setValue:@"false" forKey:@"systemCheckedOnly"];
    [self loadRequestWithDoMain:YES
                     methodName:@"micronet/findWares.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	商品、服务项目详情
 *
 *	@param 	wareId 	商品或服务项目ID
 *
 *  @return 商品或服务详情
 */
- (void)findWaresWithShopId:(NSString*)shopId page:(int)page{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [params setObject:shopId forKey:@"shopId"];
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findWares.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	收藏/绑定的商家列表
 *
 *	@param 	page    (页码) <可选, 默认为1>
 *	@param 	isFav   yes 获取收藏商家列表 no 获取绑定列表
 */
- (void)findFavoritedShop:(int)page isFav:(BOOL)isFav {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:(isFav?@"user/findFavoritedShop.htm":@"user/findBindedShop.htm")
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= 行业信息 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	获取所有行业分类
 *
 */
- (void)BusinessCategory  {
    [self loadRequestWithDoMain:YES
                     methodName:@"common/findBusinessCategory.htm"
                         params:nil
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	添加APNS
 */
- (void)setupAPNSDevice {
    //    [self addNoticeHostForIphone:true];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	取消APNS
 */
- (void)cancelAPNSDevice {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:@"removeNoticeHostForIphone" forKey:@"action"];
    [params setObject:engine.user.ID forKey:@"userid"];
    [params setObject:engine.deviceIDAPNS forKey:@"udid"];
    [self loadRequestWithDoMain:YES
                     methodName:@"User/action"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= setting =========
// 设置密码
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	设置密码
 *
 *	@param 	oldpass 	旧密码
 *	@param 	newpass 	新密码
 */
- (void)changePassword:(NSString*)oldpass new:(NSString*)newpass
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:oldpass forKey:@"oldpassword"];
    [params setObject:newpass forKey:@"password"];
    [params setObject:newpass forKey:@"password2"];
    [self loadRequestWithDoMain:YES
                     methodName:@"User/modifyPass"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	重置密码
 *
 *	@param 	phone 	电话
 *	@param 	code 	验证码
 *	@param 	newpass 	新密码
 */
//- (void)resetPassword:(NSString*)phone code:(NSString*)code new:(NSString*)newpass {
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    [params setObject:phone forKey:@"phone"];
//    [params setObject:code forKey:@"code"];
//    [params setObject:newpass forKey:@"password"];
//    [params setObject:newpass forKey:@"password2"];
//    [self loadRequestWithDoMain:YES
//                     methodName:@"User/findPass"
//                         params:params
//                   postDataType:KSTRequestPostDataTypeNormal];
//}
/**
 *
 *	重置密码
 *
 *	@param 	phone 	电话
 *	@param 	newpass 	新密码
 */
- (void)resetPassword:(NSString*)phone new:(NSString*)newpass old:(NSString *)oldpass {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (phone) {
        [params setObject:phone forKey:@"phone"];
    }
    if (newpass) {
        [params setObject:newpass forKey:@"newPassword"];
    }
    needUID  = NO;
    if (oldpass.hasValue) {
        needUID = YES;
        [params setObject:oldpass forKey:@"oldPassword"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:needUID?@"passport/updatePassword.htm":@"passport/resetPassword.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}


// ========= 评论 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	创建商品、服务项目的评论（消费后才可以评论，移动到我的消费里面）
 *
 *	@param 	content 	内容
 *	@param 	wareId      商品或服务项目ID
 *	@param 	goodBad 	(枚举GOOD/BAD) (好评、差评)
 *	@param 	anonymous 	字符串，true/false (是否匿名评论)
 */
- (void)createComment:(NSString*)content wareId:(NSString*)wareId goodBad:(CommentShowType)goodBad anonymous:(CommentShowType)anonymous {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:content forKey:@"content"];
    [params setObject:wareId forKey:@"wareId"];
    [params setObject:CommentShowString(goodBad) forKey:@"goodBad"];
    [params setObject:CommentShowString(anonymous) forKey:@"anonymous"];
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/createComment.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)createComment:(NSString *)content score:(NSString *)score referId:(NSString *)referId targetId:(NSString *)targetId targetType:(CommentType)targetType{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:content forKey:@"content"];
    if (score) {
        [params setObject:score forKey:@"score"];
    }
    if (referId) {
        [params setObject:referId forKey:@"referId"];
    }
    if (targetId.hasValue) {
        [params setObject:targetId forKey:@"targetId"];
    }
    if (CommentTypeString(targetType).hasValue) {
        [params setObject:CommentTypeString(targetType) forKey:@"targetType"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/createComment.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	获取商品、服务项目的评论	(你要取全店的评论，请传shopId，忽略wareId,你要取指定商品的评论，请传wareId，忽略shopId)
 *
 *	@param 	content 	内容
 *	@param 	wareId      商品或服务项目ID
 *	@param 	shopId      商家ID
 *	@param 	p           页码
 */
- (void)findCommentWithId:(NSString*)shopId wareId:(NSString*)wareId page:(int)page {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (shopId) {
        [params setObject:shopId forKey:@"shopId"];
    }
    if (wareId) {
        [params setObject:wareId forKey:@"wareId"];
    }
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findComment.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
    
}

-(void)findCommentWithId:(NSString *)shopId targetId:(NSString *)targetId targetType:(CommentType)targetType page:(int)page{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (shopId) {
        [params setObject:shopId forKey:@"shopId"];
    }
    if (targetId) {
        [params setObject:targetId forKey:@"targetId"];
    }
    if (CommentTypeString(targetType).hasValue) {
        [params setObject:CommentTypeString(targetType) forKey:@"targetType"];
    }
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findComment.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= 收藏 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	收藏/取消收藏 商家
 *
 *	@param 	shopId      商家ID
 */
- (void)favorite:(NSString*)shopId isFav:(BOOL)isFav {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:shopId forKey:@"shopId"];
    [self loadRequestWithDoMain:YES
                     methodName:[NSString stringWithFormat:@"shop/%@favorite.htm", isFav?@"":@"un"]
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= 消费 =========

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	获取会员余额(购买页面)
 *
 *	@param  wareId: (字符串) (购买的商品的ID)
 */
- (void)findBalance:(NSString*)wareId {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:wareId forKey:@"wareId"];
    [self loadRequestWithDoMain:YES
                     methodName:@"user/findBalance.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
    
}
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	支付购买
 *
 *	@param 	wareId                  商品ID
 *	@param 	amount                  购买数量
 *	@param 	paymentOfCard           卡金支付 <可选>
 *	@param 	paymentOfUnionCurrency  云浩币支付 <可选>
 *	@param 	password                云浩币密码，使用云浩币支付的时候必须有 <可选>
 */
- (void)buyWare:(NSString*)wareId
         amount:(NSString*)amount
  paymentOfCard:(NSString*)paymentOfCard
paymentOfUnionCurrency:(NSString*)paymentOfUnionCurrency
       password:(NSString*)password {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:wareId forKey:@"wareId"];
    [params setObject:amount forKey:@"amount"];
    if (paymentOfCard) {
        [params setObject:paymentOfCard forKey:@"paymentOfCard"];
    }
    if (paymentOfUnionCurrency && paymentOfUnionCurrency.length > 0 &&[paymentOfUnionCurrency integerValue]>0) {
        [params setObject:paymentOfUnionCurrency forKey:@"paymentOfUnionCurrency"];
        [params setObject:password forKey:@"password"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/buy.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消费/充值记录(取最近50条)
 *
 *	@param 	isConsume      0 充值记录 1 消费记录
 */
- (void)consumeRecord:(BOOL)isConsume shopId:(NSString *)shopId {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (shopId.hasValue) {
        [params setObject:shopId forKey:@"shopId"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:[NSString stringWithFormat:@"qht/%@.htm", isConsume?@"findMemberConsumeBill":@"findMemberRechargeCashRecord"]
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

// ========= 消息 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消息列表
 *
 *	type 消息类型 枚举SYSTEM/SHOP
 *	p 页码
 */
- (void)messageList:(int)p {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (p > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", p] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"message/messageList.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)removeMessageOfCenter:(NSString *)messageId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:messageId forKey:@"id"];
    [self loadRequestWithDoMain:YES
                     methodName:@"message/deleteMessage.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消息列表
 *
 *	@param mid 消息Id
 */
- (void)messageDetailWithId:(NSString*)mid {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:mid forKey:@"messageId"];
    [self loadRequestWithDoMain:YES
                     methodName:@"message/messageDetail.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}


/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消息列表
 *
 *	@param mid 消息Id
 */
- (void)findEmployeesByShopId:(NSString*)shopId page:(int)p{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:shopId forKey:@"shopId"];
    [params setObject:[NSString stringWithFormat:@"%d", p] forKey:@"p"];
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findEmployees.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}
- (void)findEmployeeById:(NSString*)employeeId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:employeeId forKey:@"id"];
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findEmployeeById.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findAppointmentsWithStatus:(NSString *)status creatorDeleted:(BOOL)deleted pageSzie:(int)pageSize page:(int)p{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    if (pageSize>0) {
       [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
    }
    if (p>1) {
      [params setObject:[NSString stringWithFormat:@"%d", p] forKey:@"p"];
    }
    
    if (deleted) {
        [params setObject:@"true" forKey:@"creatorDeleted"];
    }else{
        [params setObject:@"false" forKey:@"creatorDeleted"];
    }
    if ([status hasValue]) {
        [params setObject:status forKey:@"status"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findAppointments.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
    
}

-(void)addAppointmentByEmpId:(NSString *)empId remark:(NSString *)remark{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:empId forKey:@"targetEmpId"];
    [params setObject:remark forKey:@"remark"];
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/addAppointment.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findPromotionsByShopId:(NSString *)shopId page:(int)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (page > 1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    }
    [params setObject:shopId forKey:@"shopId"];
    
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findPromotions.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findPromotionById:(NSString *)activityId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:activityId forKey:@"id"];
    
    [self loadRequestWithDoMain:YES
                     methodName:@"shop/findPromotionById.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

/**
 * 搜索本地好友
 *
 */
-(void)searchContact:(NSString *)phoneNumber{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"phoneNumber"];
    [self loadRequestWithDoMain:YES methodName:@"circle/findFriendByPhoneNumber.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
/**
 * 搜索云联卡
 *
 */
-(void)searchUnionCard:(NSString *)phoneNumber{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"phoneNumber"];
    [self loadRequestWithDoMain:YES methodName:@"circle/searchUnionCard.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
/**
 *获取云联圈通讯录
 *
 */
-(void)contactList{
    [self loadRequestWithDoMain:YES
                     methodName:@"circle/findFriends.htm"
                         params:nil
                   postDataType:KSTRequestPostDataTypeNormal];
}
/**
 *删除联系人
 *
 */
-(void)deleteContact:(NSString *)unionCardId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:unionCardId forKey:@"unionCardId"];
    [self loadRequestWithDoMain:YES methodName:@"circle/deleteFriend.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
-(void)deleteContact:(NSString *)srcImUsername targetImUsername:(NSString *)targetImUsername{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:srcImUsername forKey:@"srcImUsername"];
    [params setObject:targetImUsername forKey:@"targetImUsername"];
    [self loadRequestWithDoMain:YES methodName:@"circle/deleteFriendBothIm.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

/**
 * 添加好友
 *
 */
-(void)addContact:(NSString *)unionCardId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:unionCardId forKey:@"unionCardId"];
    [self loadRequestWithDoMain:YES methodName:@"circle/addFriend.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)addContact:(NSString *)userName targetImUsername:(NSString *)targetName{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:userName forKey:@"srcImUsername"];
    [params setObject:targetName forKey:@"targetImUsername"];
    [self loadRequestWithDoMain:YES methodName:@"circle/addFriendBothIm.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

/**
 * 获取好友云联圈
 *
 */
-(void)findFriendBlog:(int)p pageSize:(int)pageSize{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
    [params setObject:[NSString stringWithFormat:@"%d", p] forKey:@"p"];
    
    [self loadRequestWithDoMain:YES methodName:@"circle/findFriendBlog.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findBlogByUserPhone:(NSString *)userPhone page:(int)p pageSize:(int)pageSize{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:userPhone forKey:@"phone"];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
    [params setObject:[NSString stringWithFormat:@"%d", p] forKey:@"p"];
    
    [self loadRequestWithDoMain:YES methodName:@"circle/findMyBlog.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)deleteBlogById:(NSString *)blogId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:blogId forKey:@"id"];
    
    [self loadRequestWithDoMain:YES methodName:@"circle/deleteBlogId.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findProfileByImUserNames:(NSArray *)names{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[names JSONString] forKey:@"imUsername"];
    [self loadRequestWithDoMain:YES methodName:@"circle/findProfileByImUsernameBatch.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findProfileByImUserName:(NSString *)name{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"imUsername"];
    [self loadRequestWithDoMain:YES methodName:@"circle/findProfileByImUsername.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)addBlogComment:(CricleComment *)comment{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:comment.blogId forKey:@"blogId"];
    if(comment.referId.length>0){
        [params setObject:comment.referId forKey:@"referId"];
    }
    [params setObject:comment.content forKey:@"content"];
    
    [self loadRequestWithDoMain:YES methodName:@"circle/addBlogComment.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)addBlog:(NSDictionary *)blog{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[blog objectForKey:@"content"] forKey:@"content"];
    NSArray *imageArray  = [blog objectForKey:@"img"];
    [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [NSString stringWithFormat:@"image%lu",idx+1];
        [params setObject:obj forKey:key];
    }];
    [self loadRequestWithDoMain:YES methodName:@"circle/addBlog.htm" params:params postDataType:imageArray.count>0?KSTRequestPostDataTypeMultipart:KSTRequestPostDataTypeNormal];
}


/**=============*/
-(void)getVerifyCode:(NSString *)phone Type:(PhoneVerifyType)type{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    if (type==REGISTER) {
        [params setObject:@"REGISTER" forKey:@"type"];
    }else if(type==FORGETPASSWORD){
        [params setObject:@"FORGETPASSWORD" forKey:@"type"];
    }
    needUID = NO;
    [self loadRequestWithDoMain:YES methodName:@"passport/sendVerifyCode.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)verifyCode:(NSString *)phone Code:(NSString *)verifyCode{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:verifyCode forKey:@"verifyCode"];
    needUID = NO;
    [self loadRequestWithDoMain:YES methodName:@"passport/verifyForgetCode.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)registerPassport:(NSString *)phone verifyCode:(NSString *)code Password:(NSString *)password recommendPhone:(NSString *)recommendPhone{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:code forKey:@"verifyCode"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"IOS" forKey:@"platform"];
    [params setObject:recommendPhone forKey:@"recommendPhone"];
    
    [params setObject:[NSString stringWithFormat:@"%@:%f", Sys_Name, Sys_Version] forKey:@"platformVersion"];
    NSString * ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    [params setObject:ver forKey:@"appVersion"];
    needUID = NO;
    [self loadRequestWithDoMain:YES methodName:@"passport/register.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)updateProfile:(NSDictionary *)profile{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    id avatar = [profile objectForKey:@"avatar"];
    for (NSString *key in profile) {
        [params setObject:[profile objectForKey:key] forKey:key];
    }
    [self loadRequestWithDoMain:YES methodName:@"passport/updateProfile.htm" params:params postDataType:avatar&&[avatar isKindOfClass:[UIImage class]]?KSTRequestPostDataTypeMultipart:KSTRequestPostDataTypeNormal];
}

-(void)setPushToken:(NSString *)pushToken{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:pushToken forKey:@"pushToken"];
    [self loadRequestWithDoMain:YES methodName:@"passport/setPushToken.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)randomSignature{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES methodName:@"passport/randomSignature.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findOnlineConsume{
    [self loadRequestWithDoMain:YES methodName:@"user/consumeRecord.htm" params:nil postDataType:KSTRequestPostDataTypeNormal];
}

-(void)getHomeBadgeByShopId:(NSString *)shopId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([shopId hasValue]) {
        [params setObject:shopId forKey:@"shopId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"shop/findBadge.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}


//=======================购物车相关  API================
-(void)findShoppingCartItems{
    [self loadRequestWithDoMain:YES methodName:@"micronet/findShoppingCartItems.htm" params:nil postDataType:KSTRequestPostDataTypeNormal];
}

-(void)addToShoppingCartBySkuId:(NSString *)skuId wareId:(NSString *)wareId num:(NSString *)num{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([skuId hasValue]) {
        [params setObject:skuId forKey:@"skuId"];
    }
    if ([wareId hasValue]) {
        [params setObject:wareId forKey:@"wareId"];
    }
    [params setObject:num forKey:@"num"];
    [self loadRequestWithDoMain:YES methodName:@"micronet/addToCart.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)updateShoppingCartItemById:(NSString *)cartItemId num:(NSString *)num{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([cartItemId hasValue]) {
        [params setObject:cartItemId forKey:@"id"];
    }
    if ([num hasValue]) {
        [params setObject:num forKey:@"num"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/updateShoppingCartItemById.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)updateShoppingCartItems:(NSArray *)items{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([items count]>0) {
        [params setObject:[items JSONString] forKey:@"data"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/updateShoppingCartItems.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)deleteShoppingCartItems:(NSArray *)ids{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (ids.count>0) {
        [params setObject:[ids JSONString] forKey:@"data"];
        [self loadRequestWithDoMain:YES methodName:@"micronet/deleteShoppingCartItemByIds.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
    }
}

-(void)deleteShoppingCartItemById:(NSString *)itemId{
    if (![itemId hasValue]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:itemId forKey:@"id"];
    [self loadRequestWithDoMain:YES methodName:@"micronet/deleteShoppingCartItemById.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

- (void)findAddressItems{
  [self loadRequestWithDoMain:YES methodName:@"micronet/findAddressItems.htm" params:nil postDataType:KSTRequestPostDataTypeNormal];
}

-(void)createOrDeleteAddress:(AddressItem *)item{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (item) {
        if (item.ID.hasValue) {
           [params setObject:item.ID forKey:@"id"];
        }
        if (item.receiverAddress.hasValue) {
            [params setObject:item.receiverAddress forKey:@"receiverAddress"];
        }
        if (item.receiverDistrictCode.hasValue) {
            [params setObject:item.receiverDistrictCode forKey:@"receiverDistrictCode"];
        }
        if (item.receiverName.hasValue) {
            [params setObject:item.receiverName forKey:@"receiverName"];
        }
        if (item.receiverPhone.hasValue) {
            [params setObject:item.receiverPhone forKey:@"receiverPhone"];
        }
        if (item.aliasName.hasValue) {
            [params setObject:item.aliasName forKey:@"aliasName"];
        }
        [self loadRequestWithDoMain:YES methodName:!(item.ID.hasValue)?@"micronet/createAddressItem.htm":@"micronet/editAddressItem.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
    }
}

- (void)deleteAddressById:(NSString *)addressId{
    if (![addressId hasValue]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:addressId forKey:@"id"];
    [self loadRequestWithDoMain:YES methodName:@"micronet/deleteAddressItemById.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

- (void)findBillById:(NSString *)billId{
    if (![billId hasValue]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:billId forKey:@"id"];
    [params setObject:@"true" forKey:@"fillItems"];
    [self loadRequestWithDoMain:YES methodName:@"micronet/findBillById.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

- (void)findBillByStatus:(NSString *)status page:(int)page{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:status forKey:@"status"];
    [params setObject:@"true" forKey:@"fillItems"];
    [params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    [self loadRequestWithDoMain:YES methodName:@"micronet/findBills.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

- (void)createBill:(NSString *)addressId data:(NSArray *)data{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (addressId.hasValue) {
     [params setObject:addressId forKey:@"addressId"];
    }
    
    [params setObject:[data JSONString] forKey:@"data"];
    [self loadRequestWithDoMain:YES methodName:@"micronet/createBill.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

- (void)updateBillAddress:(NSString *)billId addressId:(NSString *)addressId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (billId.hasValue) {
        [params setObject:billId forKey:@"billId"];
    }
    if (addressId.hasValue) {
        [params setObject:addressId forKeyedSubscript:@"addressId"];
    }
    
    [self loadRequestWithDoMain:YES methodName:@"micronet/updateBillAddress.htm" params:params postDataType:KSTRequestPostDataTypeNormal];

}

-(void)deleteBillById:(NSString *)billId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (billId.hasValue) {
        [params setObject:billId forKey:@"id"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/deleteBillById.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}


//========================

-(void)findWareCategoryByShopId:(NSString *)shopId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (shopId.hasValue) {
        [params setObject:shopId forKey:@"orgId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/findWareCats.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)getRedEnvelopeSettingByShopId:(NSString *)shopId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (shopId.hasValue) {
        [params setObject:shopId forKey:@"orgId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/redEnvelopeSetting.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)pickRedEnvelope:(NSString *)shopId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (shopId.hasValue) {
        [params setObject:shopId forKey:@"orgId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/pickRedEnvelope.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findRedEnvelopes{
    [self loadRequestWithDoMain:YES methodName:@"micronet/findRedEnvelopes.htm" params:nil postDataType:KSTRequestPostDataTypeNormal];
}


-(void)findEmpWorks:(NSString *)orgId empId:(NSString *)empId p:(int)p{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (empId.hasValue) {
        [params setObject:empId forKey:@"empId"];
    }
    if (orgId.hasValue) {
        [params setObject:orgId forKey:@"orgId"];
    }
    
    if (p>1) {
        [params setObject:[NSString stringWithFormat:@"%i",p] forKey:@"p"];
    }
    
    [self loadRequestWithDoMain:YES methodName:@"micronet/findEmpWorks.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findEmpWorkDetail:(NSString *)workId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (workId.hasValue) {
        [params setObject:workId forKey:@"id"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/findEmpWorkDetail.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findLimitSettings:(NSString *)ogrId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (ogrId.hasValue) {
        [params setObject:ogrId forKey:@"orgId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/findLimitSettings.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)createAppointment:(NSString *)workId Ymd:(NSString *)ymd Hm:(NSString *)hm Address:(NSString *)address Remark:(NSString *)remark{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (workId.hasValue) {
        [params setObject:workId forKey:@"empWorkId"];
    }
    if (ymd.hasValue) {
        [params setObject:ymd forKey:@"ymd"];
    }
    if (hm.hasValue) {
        [params setObject:hm forKey:@"hm"];
    }
    if (address.hasValue) {
        [params setObject:address forKey:@"address"];
    }
    if (remark.hasValue) {
        [params setObject:remark forKey:@"remark"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/createAppointment.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
-(void)updateAppointmentAddress:(NSString *)address AppointmentId:(NSString *)appId OrAddressId:(NSString *)addressId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (address.hasValue) {
        [params setObject:address forKey:@"address"];
    }
    if (appId.hasValue) {
        [params setObject:appId forKey:@"id"];
    }
    if (addressId.hasValue) {
        [params setObject:addressId forKey:@"addressId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/updateAppointmentAddress.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)deleteAppointmentByCreator:(NSString *)appointmentId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (appointmentId.hasValue) {
        [params setObject:appointmentId forKey:@"id"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/deleteAppointmentByCreator.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}

-(void)addEmpWorkComment:(NSString *)content score:(NSString *)score referId:(NSString *)referId targetId:(NSString *)targetId{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (content.hasValue) {
        [params setObject:content forKey:@"content"];
    }
    if (score.hasValue) {
        [params setObject:score forKey:@"score"];
    }
    if (targetId.hasValue) {
        [params setObject:targetId forKey:@"empWorkId"];
    }
    if (referId.hasValue) {
        [params setObject:referId forKey:@"appointmentId"];
    }
    [self loadRequestWithDoMain:YES methodName:@"micronet/addEmpWorkComment.htm" params:params postDataType:KSTRequestPostDataTypeNormal];
}
@end
