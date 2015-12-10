//
//  AMYMainMenuViewController.m
//  Slots-Game
//
//  Created by Amy Joscelyn on 12/10/15.
//  Copyright © 2015 Amy Joscelyn. All rights reserved.
//

#import "AMYMainMenuViewController.h"
#import "AMYSlotsGameViewController.h"

@interface AMYMainMenuViewController () <AMYSlotsGameViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *playersTotalTickets;
@property (nonatomic) NSInteger totalTickets;

@end

@implementation AMYMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AMYSlotsGameViewController *slotsGame = [[AMYSlotsGameViewController alloc] init];
    self.playersTotalTickets.text = [NSString stringWithFormat:@"Your Tickets: %lu", slotsGame.tickets ];
}

- (void)AMYSlotsGameViewController:(AMYSlotsGameViewController *)viewController didCashOut:(NSInteger)tickets
{
    self.totalTickets += tickets;
    self.playersTotalTickets.text = [NSString stringWithFormat:@"Your Tickets: %lu", tickets];
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AMYSlotsGameViewController *slotsGameDVC = segue.destinationViewController;
    slotsGameDVC.delegate = self;
}

@end
