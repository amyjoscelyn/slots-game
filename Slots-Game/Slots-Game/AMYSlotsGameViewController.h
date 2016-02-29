//
//  AMYSlotsGameViewController.h
//  Slots-Game
//
//  Created by Amy Joscelyn on 12/10/15.
//  Copyright © 2015 Amy Joscelyn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMYSlotsGameViewController;

@protocol AMYSlotsGameViewControllerDelegate <NSObject>

- (void)AMYSlotsGameViewController :(AMYSlotsGameViewController *)viewController didCashOut:(NSInteger)tickets;

@end

@interface AMYSlotsGameViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *fruitPicker;
@property (strong, nonatomic) IBOutlet UIButton *spinButton;

@property (strong, nonatomic) NSArray *fruitsArray;
@property (nonatomic) NSInteger tickets;

@property (weak, nonatomic) id<AMYSlotsGameViewControllerDelegate> delegate;

@end
