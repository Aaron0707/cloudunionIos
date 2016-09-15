//
//  BSClient.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Declare.h"
@class CricleComment,AddressItem;

typedef enum
{
    REGISTER ,
    FORGETPASSWORD,
}PhoneVerifyType;



@interface BSClient : NSObject

@property (nonatomic, strong) NSString      * errorMessage;
@property (nonatomic, strong) NSIndexPath   * indexPath;
@property (nonatomic, strong) NSString      * tag;
@property (nonatomic, assign) BOOL          hasError;
@property (nonatomic, assign) BOOL          isOldToken;
@property (nonatomic, assign) int           customErrorCode;

#pragma mark - Init
- (id)initWithDelegate:(id)del action:(SEL)act;

- (void)showAlert;

- (void)cancel;

#pragma mark - Request

// ========= Login&Reg =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	账号登录
 *
 *	@param 	phone 	手机号码
 *	@param 	pwd 	密码
 */
- (void)loginWithUserPhone:(NSString *)phone
                  password:(NSString *)pwd;
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	注销登录
 *
 */
- (void)logout;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	用户详细资料
 *
 */
- (void)MyInfo;
- (void)findProFileByPhone:(NSString *)phone;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	修改用户头像
 *
 *	@param 	head 	头像
 */
- (void)editAvatar:(UIImage*)head;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	会员账户详情
 *
 *	@param 	memberId 	会员id
 */
- (void)memberDetail:(NSString*)memberId;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	首页轮播图片
 *
 */
- (void)gallery;

// ========= 获取城市列表 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	城市查询接口
 *	@param query 关键字<可选>
 *
 */
- (void)findCityIfNeedKey:(NSString*)key;

// ========= 获取省份列表 =========
/**
 *	Copyright © 2014 Cloud Inc. All rights reserved.
 *
 *
 */
-(void)findProvinces:(NSString *)key;
-(void)findCitysByProvinceCode:(NSString *)code query:(NSString *)query;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	查找所有商圈
 *
 *	@param 	cityCode 	城市编号
 */
- (void)findDistrict:(NSString*)cityCode;

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
- (void)nearbyShop:(NSString*)businessCategoryId latitude:(NSString*)latitude longitude:(NSString*)longitude page:(int)page;

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
              page:(int)page;
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	商家详情
 *
 *	@param 	shopId 	商家ID
 *	@param 	page    (页码) <可选, 默认为1>
 */
- (void)findShopDetailWithID:(NSString*)shopId page:(int)page;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	商品、服务项目详情
 *
 *	@param 	wareId 	商品或服务项目ID
 *
 *  @return 商品或服务详情
 */
- (void)findWareWithId:(NSString*)wareId;
- (void)findwareWithCategoryId:(NSString *)categoryId shopId:(NSString *)shopId query:(NSString *)query page:(int)p;
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	收藏的商家列表
 *
 *	@param 	page    (页码) <可选, 默认为1>
 */
- (void)findFavoritedShop:(int)page isFav:(BOOL)isFav;


// ========= 行业信息 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	获取所有行业分类
 *
 */
- (void)BusinessCategory;

// ========= APNS =========
// 添加APNS
- (void)setupAPNSDevice;
// 取消APNS
- (void)cancelAPNSDevice;

// ========= setting =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	设置密码
 *
 *	@param 	oldpass 	旧密码
 *	@param 	newpass 	新密码
 */
- (void)changePassword:(NSString*)oldpass new:(NSString*)newpass;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	重置密码
 *
 *	@param 	phone 	电话
 *	@param 	code 	验证码
 *	@param 	newpass 	新密码
 */
//- (void)resetPassword:(NSString*)phone code:(NSString*)code new:(NSString*)newpass;
- (void)resetPassword:(NSString*)phone new:(NSString*)newpass old:(NSString *)oldpass;

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
- (void)createComment:(NSString*)content wareId:(NSString*)wareId goodBad:(CommentShowType)goodBad anonymous:(CommentShowType)anonymous;
- (void)createComment:(NSString*)content score:(NSString *)score referId:(NSString*)referId targetId:(NSString *)targetId targetType:(CommentType)targetType;

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
- (void)findCommentWithId:(NSString*)shopId wareId:(NSString*)wareId page:(int)page;
- (void)findCommentWithId:(NSString*)shopId targetId:(NSString*)targetId targetType:(CommentType)targetType page:(int)page;

// ========= 收藏 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	收藏商家/取消收藏
 *
 *	@param 	shopId      商家ID
 */
- (void)favorite:(NSString*)shopId isFav:(BOOL)isFav;

// ========= 消费 =========

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	获取会员余额(购买页面)
 *
 *	@param  wareId: (字符串) (购买的商品的ID)
 */
- (void)findBalance:(NSString*)wareId;

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
       password:(NSString*)password;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消费/充值记录(取最近50条)
 *
 *	@param 	isConsume      0 充值记录 1 消费记录
 */
- (void)consumeRecord:(BOOL)isConsume shopId:(NSString *)shopId;

// ========= 消息 =========
/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消息列表
 *
 *	@param type 消息类型 枚举SYSTEM/SHOP
 *	@param p 页码
 */
- (void)messageList:(int)p;

-(void)removeMessageOfCenter:(NSString *)messageId;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	消息列表
 *
 *	@param mid 消息Id
 */
- (void)messageDetailWithId:(NSString*)mid;

- (void)findOpenShop:(NSString *)shopId;
- (void)findOpenShop;

- (void)findWaresWithShopId:(NSString*)shopId page:(int)page;
- (void)findEmployeesByShopId:(NSString*)shopId page:(int)p;
- (void)findEmployeeById:(NSString*)employeeId;

/**
 *获取预约记录
 */
-(void)findAppointmentsWithStatus:(NSString *)status creatorDeleted:(BOOL)deleted pageSzie:(int)pageSize page:(int)p;

-(void)addAppointmentByEmpId:(NSString *)empId remark:(NSString*)remark;


/**
 * 获取活动列表
 */

-(void)findPromotionsByShopId:(NSString *)shopId page:(int)page;
-(void)findPromotionById:(NSString *)activityId;

/**
 * 获取云联好友
 */
-(void)searchContact:(NSString*)phoneNumber;
-(void)searchUnionCard:(NSString *)phoneNumber;

/**
 * 获取通讯录
 */
-(void)contactList;
/**
 *
 *	删除好友
 *
 */
-(void)deleteContact:(NSString*)unionCardId;
-(void)deleteContact:(NSString *)srcImUsername targetImUsername:(NSString *)targetImUsername;

/**
 * 通过电话号码添加好友
 *
 */
-(void)addContact:(NSString *)phoneNumber;

/**
 * 通过名称添加好友
 *
 */
-(void)addContact:(NSString *)userName targetImUsername:(NSString *) targetName;

/**
 * 获取好友云联圈
 *
 */
-(void)findFriendBlog:(int)page pageSize:(int)pageSze;

/**
 *删除blog
 *
 */
-(void)deleteBlogById:(NSString*)blogId;

/**
 *添加blog评论
 *
 */
-(void)addBlogComment:(CricleComment *)comment;

/**
 *添加blog
 *
 */
-(void)addBlog:(NSDictionary *)blog;

-(void)findProfileByImUserNames:(NSArray *)names;
-(void)findProfileByImUserName:(NSString *)name;

/**===============登录相关===============*/

/**
 *获取验证码
 *
 */
-(void)getVerifyCode:(NSString *)phone Type:(PhoneVerifyType)type;

/**
 *验证忘记密码的验证码
 *
 */
-(void)verifyCode:(NSString *)phone Code:(NSString *)verifyCode;

/**
 *注册
 *
 */
-(void)registerPassport:(NSString *)phone verifyCode:(NSString *)code Password:(NSString *)password recommendPhone:(NSString *)recommendPhone;

/**
 *更新个人资料
 *
 */
-(void)updateProfile:(NSDictionary *)profile;



//推送
-(void)setPushToken:(NSString *)pusfindProvinceshToken;

//随机获取签名
-(void)randomSignature;

-(void)findBlogByUserPhone:(NSString *)userPhone page:(int)p pageSize:(int)pageSize;

-(void)findOnlineConsume;


-(void)getHomeBadgeByShopId:(NSString *)shopId;


//=======================购物车相关  API================
-(void)findShoppingCartItems;

-(void)addToShoppingCartBySkuId:(NSString *)skuId wareId:(NSString *)wareId num:(NSString *)num;

-(void)updateShoppingCartItemById:(NSString *)cartItemId num:(NSString *)num;

-(void)updateShoppingCartItems:(NSArray *)items;

-(void)deleteShoppingCartItems:(NSArray *)ids;

-(void)deleteShoppingCartItemById:(NSString *)itemId;

//=========================地址信息管理==================
- (void)findAddressItems;
- (void)createOrDeleteAddress:(AddressItem *)item;
- (void)deleteAddressById:(NSString *)addressId;

//=========================订单查询==================
- (void)findBillById:(NSString *)billId;
- (void)findBillByStatus:(NSString *)status page:(int)page;
- (void)createBill:(NSString *)addressId data:(NSArray *)data;
- (void)updateBillAddress:(NSString *)billId addressId:(NSString *)addressId;
- (void)deleteBillById:(NSString *)billId;

//=========================获取商品类别==================
- (void)findWareCategoryByShopId:(NSString *)shopId;

//=========================获取红包设置=================
-(void)getRedEnvelopeSettingByShopId:(NSString *)shopId;
-(void)pickRedEnvelope:(NSString *)shopId;
-(void)findRedEnvelopes;

//=========================预约管理=================
-(void)findEmpWorks:(NSString *)orgId empId:(NSString *)empId p:(int)p;
-(void)findEmpWorkDetail:(NSString *)workId;
-(void)findLimitSettings:(NSString *)ogrId;
-(void)createAppointment:(NSString *)workId Ymd:(NSString *)ymd Hm:(NSString *)hm Address:(NSString *)address Remark:(NSString * )remark;

-(void)updateAppointmentAddress:(NSString *)address AppointmentId:(NSString*)appId OrAddressId:(NSString*)addressId;

-(void)deleteAppointmentByCreator:(NSString *)appointmentId;
-(void)addEmpWorkComment:(NSString*)content score:(NSString*)score referId:(NSString*)referId targetId:(NSString *)targetId;
@end
