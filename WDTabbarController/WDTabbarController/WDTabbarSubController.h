//
//  WDTabbarSubController.h
//  testTabbarController
//
//  Created by tb on 17/3/31.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WDTabbarScreenWidth [UIScreen mainScreen].bounds.size.width
#define WDTabbarScreenHeight [UIScreen mainScreen].bounds.size.height
#define WDTabbarWidthRatio [UIScreen mainScreen].bounds.size.width/750.0
#define WDTabbarHeightRatio [UIScreen mainScreen].bounds.size.height/1334.0

@protocol WDTabbarSubControllerDelegate <NSObject>

@optional

- (void)clickButtonWithinController:(id)controller index:(NSUInteger)vcIndex toViewControllerIndex:(NSUInteger)toIndex;

@end

@interface WDTabbarSubController : UIViewController

@property (nonatomic,assign) id<WDTabbarSubControllerDelegate> delegate;

@end
