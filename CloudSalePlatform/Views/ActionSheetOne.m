//
//  ActionSheetOne.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/11.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "ActionSheetOne.h"
#import "UIButton+NSIndexPath.h"
#import "NSDictionaryAdditions.h"

@interface ActionSheetOne ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * titleOfTab;
@property (nonatomic, strong) NSArray * titleOfBtn;
@property (nonatomic, strong) UIView * frameView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic) int indexNumber;
@end

@implementation ActionSheetOne
@synthesize frameView,delegate,tableView;


-(id)initWithActionTab:(NSArray *)tabs TextViews:(NSArray *)tViews withDelegate:(id)del{
    CGRect rect = [UIScreen mainScreen].bounds;
    self = [self init];
    if (self) {
        self.frame = rect;
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        
        [self addSubview:self.frameView];
        
        [self.frameView addSubview:self.tableView];
        
        self.titleOfTab = tabs;
        self.titleOfBtn = tViews;
        self.delegate = del;
    }
    return self;
}

-(void)dealloc{
    
}

#pragma mark - table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"UITableViewCell";
    UITableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIButton * button1  = VIEWWITHTAG(cell.contentView, 101);
    UIButton * button2  = VIEWWITHTAG(cell.contentView, 102);
    UIButton * button3  = VIEWWITHTAG(cell.contentView, 103);
    UIButton * button4  = VIEWWITHTAG(cell.contentView, 104);
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        button2 = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 80, 80)];
        button3 = [[UIButton alloc]initWithFrame:CGRectMake(160, 0, 80, 80)];
        button4 = [[UIButton alloc]initWithFrame:CGRectMake(240, 0, 80, 80)];
        button1.tag = 101;
        button2.tag = 102;
        button3.tag = 103;
        button4.tag = 104;
        
        button1.selected = YES;
        
        [button1 addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
        [button4 addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:button1];
        [cell.contentView addSubview:button2];
        [cell.contentView addSubview:button3];
        [cell.contentView addSubview:button4];
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, indexPath.row==0?40:80, tableView.width, 1)];
        [line setBackgroundColor:MygrayColor];
        [cell.contentView addSubview:line];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 80)];
        [line1 setBackgroundColor:MygrayColor];
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 1, 80)];
        [line2 setBackgroundColor:MygrayColor];
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(240, 0, 1, 80)];
        [line3 setBackgroundColor:MygrayColor];
        
        [cell.contentView addSubview:line1];
        [cell.contentView addSubview:line2];
        [cell.contentView addSubview:line3];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row ==0) {
        button1.height =
        button2.height =
        button3.height =
        button4.height = 40;
        
    }else{
        button1.height =
        button2.height =
        button3.height =
        button4.height = 80;
    }
    
    button1.indexPath =
    button2.indexPath =
    button3.indexPath =
    button4.indexPath = indexPath;
    
    button1.enabled =
    button2.enabled =
    button3.enabled =
    button4.enabled = NO;
    
   
    for (int i = 0; i<4; i++) {
        UIButton * button  = VIEWWITHTAG(cell.contentView, 101+i);
        if (indexPath.row ==0) {
            [button graySquareStyle];
            if (i<self.titleOfTab.count) {
                [button setTitle:[self.titleOfTab objectAtIndex:i] forState:UIControlStateNormal];
                button.enabled = YES;
            }
            if (button.selected) {
                self.indexNumber = i;
            }
        }else{
            NSArray * tem = [self.titleOfBtn objectAtIndex:self.indexNumber];
            if ((indexPath.row-1)*4+i <tem.count) {
                NSDictionary *dic = [tem objectAtIndex:(indexPath.row-1)*4+i];
                
                NSString * str1 = [dic getStringValueForKey:@"startHm" defaultValue:@"0000"];
                
                NSString * str2 = [dic getStringValueForKey:@"inUse" defaultValue:@""];

                NSString * str;
                if ([@"1" isEqualToString:str2]) {
                    button.enabled = YES;
                    str = [NSString stringWithFormat:@"%@:%@\r\n%@",[str1 substringToIndex:2],[str1 substringFromIndex:2],@"可预约"];
                     [button pinkSquareStyle];
                    button.alpha = 1;
                }else{
                    str = [NSString stringWithFormat:@"%@:%@\r\n%@",[str1 substringToIndex:2],[str1 substringFromIndex:2],@"被预约"];
                    [button whiteSquareStyle];
                    button.alpha = 0.4;
                }
                
                NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:str];
                [att addAttribute:NSForegroundColorAttributeName value:button.enabled?[UIColor whiteColor]:[UIColor blackColor] range:NSMakeRange(0, 5)];
                [att addAttribute:NSForegroundColorAttributeName value:button.enabled?[UIColor whiteColor]:MyPinkColor range:NSMakeRange(5, str.length-5)];
                
                [button setAttributedTitle:att forState:UIControlStateNormal];
                button.titleLabel.numberOfLines = 2;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                button.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);

            }
        }
        
    }
    
    return cell;
}



#pragma mark - Presentation

-(void)changeTime:(UIButton *)sender{
    if (sender.indexPath.row==0) {
        for (UIView * sub in sender.superview.subviews) {
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)sub;
                if (sender.tag == btn.tag) {
//                    if (!btn.selected) {
                        btn.selected = YES;
//                    }
                }else{
                    btn.selected = NO;
                }
            }
        }
        [tableView reloadData];
        return;
    }
    if([delegate respondsToSelector:@selector(actionSheet:didDismissWithObj:)]){
        
        NSArray * temp = [self.titleOfBtn objectAtIndex:self.indexNumber];
        NSDictionary * dic = [temp objectAtIndex:(sender.indexPath.row-1)*4+sender.tag-101];
        [delegate actionSheet:self didDismissWithObj:dic];
    }
    [self hide:sender];
}

- (UIView*)frameView {
    if (!frameView) {
        frameView = [[UIView alloc] initWithFrame:[self frame]];
        [frameView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        frameView.backgroundColor = [UIColor clearColor];
        //  Hide the buttons
        //        [frameView setTransform:CGAffineTransformMakeTranslation(0, frameView.height)];
        frameView.top = frameView.height;
    }
    return frameView;
}

-(UITableView *)tableView{
    
    if (!tableView) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-280, self.frame.size.width, 280) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled  = NO;
        
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return tableView;
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView
     animateWithDuration:0.45
     animations:^{
         frameView.top = 0;
     }
     completion:^(BOOL finished) {
         if (finished) {
             [self.tableView reloadData];
         }
     }];
}

- (void)hide:(UIButton*)sender {
    [UIView
     animateWithDuration:0.3
     animations:^{
         frameView.top = frameView.height;
     }
     completion:^(BOOL finished) {
         if (finished) {
             [self removeFromSuperview];
         }
     }];
    
}


@end
