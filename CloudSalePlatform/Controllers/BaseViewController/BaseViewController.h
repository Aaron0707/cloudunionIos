//
//  BaseViewController.h
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSClient.h"
#import "BSEngine.h"

#define DefaultKeyBoardHeight 216.f

@interface BaseViewController : UIViewController {
    BSClient    * client;
    CGFloat     keyboardHeight;
    id          currentView;
    UIView      * currentInputView;
    UINib       * nib;
    BOOL        isFirstAppear;
    int         currentPage;
    int         totalCount;
    int         pageCount;
    int         maxPage;
    int         maxID;
    int         sinceID;
    BOOL        needToLoad;
    UIView      * refreshControl;
    BOOL        isloadByslime;
}

@property (nonatomic, assign) BOOL willShowBackButton;
@property (nonatomic, assign) BOOL loading;

- (void)popViewController;
- (void)pushViewController:(id)con;

/**
 *	Copyright © 2014 Kiwaro Inc. All rights reserved.
 *
 *	show tip text from top or bottom
 *
 *	@param 	text 	tip text
 *	@param 	top 	YES for top, NO for bottom
 */
- (void)showTipText:(NSString*)text top:(BOOL)top;
- (void)sendNotificationInfoUpdate:(id)obj;
- (void)showAlert:(id)text isNeedCancel:(BOOL)isNeedCancel;
- (void)showAlertWithTag:(id)text isNeedCancel:(BOOL)isNeedCancel tag:(int)tag;
- (void)showText:(id)text;

- (void)setLoading:(BOOL)bl content:(NSString*)con;
- (void)showBackButton;
- (BOOL)showLoginIfNeed;
- (void)presentModalController:(id)con animated:(BOOL)animated;
- (void)dismissModalController:(BOOL)animated;

/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	Set bar button items with image, do not worry about the width of the button either
 *
 *	@param 	image 	Image for button
 *	@param 	himage 	Highlighted Image for button
 *	@param 	rbtn 	title for button
 *	@param 	sel 	The selector which the button would trigger
 */
- (void)setRightBarButton:(NSString*)rbtn selector:(SEL)sel;
- (void)setLeftBarButton:(NSString*)rbtn selector:(SEL)sel;

- (void)setRightBarButtonImage:(UIImage*)img highlightedImage:(UIImage*)himg selector:(SEL)sel;
- (void)setLeftBarButtonImage:(UIImage*)img selector:(SEL)sel;
- (void)setLeftBarButton:(NSString*)title image:(UIImage*)img highlightedImage:(UIImage*)himg selector:(SEL)sel;

- (UIButton*)buttonWithTitle:(NSString*)title image:(UIImage*)img selector:(SEL)sel;
/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	Start request when possible and - (void)prepareRequest should be called
 */
- (BOOL)startRequest;

/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	call back while request has been done
 *
 *	@param 	sender 	BSClient object
 *	@param 	obj 	recieved objects
 *
 *	@return YES when sucess, NO for Error
 */
- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary*)obj;

/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	updatePageInfo
 *
 *	@param 	obj 	BSClient object
 *
 */
- (void)updatePageInfo:(id)obj;

#pragma mark - Public Methods
/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	Start request when possible and - (void)prepareLoadMoreRequest should be called
 *
 *	@param 	reqID 	request identifier
 */
- (void)loadMoreRequest;
/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	Resign keyboard for all subviews and subview's subviews for a view
 *
 *	@param 	aView 	The view with Text Input Object that you want to resign
 */
- (void)resignAllKeyboard:(UIView*)aView;
/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	self.edgesForExtendedLayout = UIRectEdgeNone;
 *
 */
- (void)setEdgesNone;

/**
 *	Copyright © 2013 Kiwaro Inc. All rights reserved.
 *
 *	load Next page
 *
 */
- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID;

-(void)createMyBadge:(UIView *)targetView Value:(NSString *)value Left:(BOOL)left;
@end
