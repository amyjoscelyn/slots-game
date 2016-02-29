//
//  AMYRulesAndRankingsViewController.m
//  Slots-Game
//
//  Created by Amy Joscelyn on 12/10/15.
//  Copyright © 2015 Amy Joscelyn. All rights reserved.
//

#import "AMYRulesAndRankingsViewController.h"

@interface AMYRulesAndRankingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation AMYRulesAndRankingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backButton.layer.cornerRadius = self.backButton.frame.size.height/2;
}

- (IBAction)backButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
