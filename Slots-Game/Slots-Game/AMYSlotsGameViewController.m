//
//  AMYSlotsGameViewController.m
//  Slots-Game
//
//  Created by Amy Joscelyn on 12/10/15.
//  Copyright © 2015 Amy Joscelyn. All rights reserved.
//

#import "AMYSlotsGameViewController.h"

@interface AMYSlotsGameViewController ()

- (IBAction)spin:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *currentTicketAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalTicketWinnings;
@property (weak, nonatomic) IBOutlet UIButton *componentOneButton;
@property (weak, nonatomic) IBOutlet UIButton *componentTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *componentThreeButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationTwoLabel;

@property (weak, nonatomic) IBOutlet UIButton *rulesAndRanksButton;

@property (nonatomic) NSInteger amountOfTicketsWon;
@property (nonatomic) BOOL justWon;
@property (nonatomic) BOOL componentOneHeld;
@property (nonatomic) BOOL componentTwoHeld;
@property (nonatomic) BOOL componentThreeHeld;
@property (nonatomic) NSUInteger rowOne;
@property (nonatomic) NSUInteger rowTwo;
@property (nonatomic) NSUInteger rowThree;

@end

@implementation AMYSlotsGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fruitsArray = @[@"🍎", @"🍊", @"🍌", @"🍉", @"🍒", @"🍇", @"🍒", @"💎", @"🍇", @"🍉", @"🍒", @"🍆", @"🍎", @"🍊", @"🍌", @"🍀", @"🍇", @"🍒", @"🍎", @"🍉", @"🍌", @"🍇", @"🍆", @"🍎", @"🍊", @"🍇", @"🍉", @"🍌", @"🍒", @"🍇", @"🍒", @"🍌", @"🍉", @"🍆", @"🍀", @"🍊", @"🍇", @"🍌", @"🍉", @"🍇", @"🍒", @"🍎", @"🍉", @"🍌", @"🍆", @"🍒", @"🍊", @"🍇", @"🍒", @"🍌", @"🍎", @"🍒"];
    
    self.fruitPicker.dataSource = self;
    self.fruitPicker.delegate = self;
    
    self.notificationOneLabel.text = @"";
    self.notificationTwoLabel.text = @"";
    
    self.tickets = 100;
    self.currentTicketAmount.text = [NSString stringWithFormat:@"Your Tickets: %li", self.tickets];
    self.totalTicketWinnings.text = @"Total Tickets Won: 0";
    
    self.rulesAndRanksButton.layer.cornerRadius = self.rulesAndRanksButton.frame.size.height/2;
    
    for (NSUInteger i = 0; i < self.fruitPicker.numberOfComponents; i++)
    {
        NSUInteger randomRow = arc4random_uniform((int)self.fruitsArray.count);
        [self.fruitPicker selectRow:randomRow inComponent:i animated:YES];
    }
    self.justWon = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.fruitsArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.fruitsArray[row];
}

- (IBAction)spin:(UIPickerView *)sender
{
    [self playerHasEnoughTickets];
}

- (void)playerHasEnoughTickets
{
    BOOL playerHasEnoughTickets = YES;
    
    if (self.componentOneHeld)
    {
        playerHasEnoughTickets = [self enoughTicketsToHoldSlots];
    }
    if (self.componentTwoHeld)
    {
        playerHasEnoughTickets = [self enoughTicketsToHoldSlots];
    }
    if (self.componentThreeHeld)
    {
        playerHasEnoughTickets = [self enoughTicketsToHoldSlots];
    }
    
    if (playerHasEnoughTickets && self.tickets >= 5)
    {
        self.tickets -= 5;
        self.currentTicketAmount.text = [NSString stringWithFormat:@"Your Tickets: %li", self.tickets];
        [self spinTheFruits];
    }
    else
    {
        [self.componentOneButton setTitle:@"⚪️" forState:UIControlStateNormal];
        [self.componentTwoButton setTitle:@"⚪️" forState:UIControlStateNormal];
        [self.componentThreeButton setTitle:@"⚪️" forState:UIControlStateNormal];
        self.componentOneHeld = NO;
        self.componentTwoHeld = NO;
        self.componentThreeHeld = NO;
        
        self.notificationOneLabel.text = @"Sorry";
        self.notificationTwoLabel.text = @"Not enough tickets.";
        
        [self showHiddenNotifcationLabels];
    }
}

- (BOOL)enoughTicketsToHoldSlots
{
    if (self.tickets >= 15)
    {
        self.tickets -= 10;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)showHiddenNotifcationLabels
{
    self.notificationOneLabel.hidden = NO;
    self.notificationTwoLabel.hidden = NO;
}

- (void)spinTheFruits
{
    self.notificationOneLabel.hidden = YES;
    self.notificationTwoLabel.hidden = YES; //make this into separate method?
    
    NSUInteger randomRow = 0;
    NSUInteger amountOfFruits = self.fruitsArray.count;
    
    if (!self.componentOneHeld)
    {
        randomRow = arc4random_uniform((int)amountOfFruits);
        [self.fruitPicker selectRow:randomRow inComponent:0 animated:YES];
    }
    if (!self.componentTwoHeld)
    {
        randomRow = arc4random_uniform((int)amountOfFruits);
        [self.fruitPicker selectRow:randomRow inComponent:1 animated:YES];
    }
    if (!self.componentThreeHeld)
    {
        randomRow = arc4random_uniform((int)amountOfFruits);
        [self.fruitPicker selectRow:randomRow inComponent:2 animated:YES];
    }
    [self postSpinActions];
}

- (void)postSpinActions
{
    BOOL playerWinsALot = [self playerHasWonThreeInARow];
    BOOL playerWinsALittle = [self playerHasWonTwoInARow];
    
    NSString *title = @"";
    NSString *message = @"";
    
    [self.componentOneButton setTitle:@"⚪️" forState:UIControlStateNormal];
    [self.componentTwoButton setTitle:@"⚪️" forState:UIControlStateNormal];
    [self.componentThreeButton setTitle:@"⚪️" forState:UIControlStateNormal];
    
    self.componentOneHeld = NO;
    self.componentTwoHeld = NO;
    self.componentThreeHeld = NO;
    
    if (playerWinsALot)
    {
        NSUInteger winnings = [self playersWinningsWithFruitsInARow:3];
        self.amountOfTicketsWon += winnings;
        self.tickets += winnings;
        self.justWon = YES;
        
        title = [NSString stringWithFormat:@"You've won %lu tickets!", winnings];
        message = @"Wanna play again?";
    }
    else if (playerWinsALittle)
    {
        NSUInteger winnings = [self playersWinningsWithFruitsInARow:2];
        self.amountOfTicketsWon += winnings;
        self.tickets += winnings;
        self.justWon = YES;
        
        title = [NSString stringWithFormat:@"You've won %lu tickets!", winnings];
        message = @"Wanna play again?";
    }
    else
    {
        self.justWon = NO;
    }
    self.totalTicketWinnings.text = [NSString stringWithFormat:@"Total Tickets Won: %li", self.amountOfTicketsWon];
    self.currentTicketAmount.text = [NSString stringWithFormat:@"Your Tickets: %li", self.tickets];
    
    self.notificationOneLabel.text = title;
    self.notificationTwoLabel.text = message;
    
    [self showHiddenNotifcationLabels];
}

- (BOOL)playerHasWonThreeInARow
{
    NSUInteger rowOne = [self.fruitPicker selectedRowInComponent:0];
    NSUInteger rowTwo = [self.fruitPicker selectedRowInComponent:1];
    NSUInteger rowThree = [self.fruitPicker selectedRowInComponent:2];
    
    return (self.fruitsArray[rowOne] == self.fruitsArray[rowTwo] && self.fruitsArray[rowTwo] == self.fruitsArray[rowThree]);
}

- (BOOL)playerHasWonTwoInARow
{
    NSUInteger rowOne = [self.fruitPicker selectedRowInComponent:0];
    NSUInteger rowTwo = [self.fruitPicker selectedRowInComponent:1];
    
    return self.fruitsArray[rowOne] == self.fruitsArray[rowTwo];
}

- (NSInteger)playersWinningsWithFruitsInARow:(NSUInteger)amountOfFruitsInARow
{
    NSUInteger rowOne = [self.fruitPicker selectedRowInComponent:0];
    NSUInteger winnings = 0;
    
    if (amountOfFruitsInARow == 3)
    {
        if ([self.fruitsArray[rowOne] isEqualToString:@"🍒"])
        {
            winnings = 50;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍇"])
        {
            winnings = 100;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍌"])
        {
            winnings = 250;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍉"])
        {
            winnings = 500;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍎"])
        {
            winnings = 750;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍊"])
        {
            winnings = 1000;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍆"])
        {
            winnings = 1500;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍀"])
        {
            winnings = 5000;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"💎"])
        {
            winnings = 10000;
        }
    }
    else if (amountOfFruitsInARow == 2)
    {
        if ([self.fruitsArray[rowOne] isEqualToString:@"🍒"])
        {
            winnings = 5;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍇"])
        {
            winnings = 10;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍌"])
        {
            winnings = 25;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍉"])
        {
            winnings = 50;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍎"])
        {
            winnings = 75;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍊"])
        {
            winnings = 100;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍆"])
        {
            winnings = 150;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"🍀"])
        {
            winnings = 500;
        }
        else if ([self.fruitsArray[rowOne] isEqualToString:@"💎"])
        {
            winnings = 1000;
        }
        
    }
    return winnings;
}

- (IBAction)componentOneButtonTapped:(id)sender
{
    if (self.justWon)
    {
        [self holdingSlotsError];
        
        return;
    }
    
    if (self.componentOneHeld)
    {
        self.componentOneHeld = NO;
        [self.componentOneButton setTitle:@"⚪️" forState:UIControlStateNormal];
    }
    else
    {
        self.componentOneHeld = YES;
        [self.componentOneButton setTitle:@"🔵" forState:UIControlStateNormal];
    }
}

- (IBAction)componentTwoButtonTapped:(id)sender
{
    if (self.justWon)
    {
        [self holdingSlotsError];
        
        return;
    }
    if (self.componentTwoHeld)
    {
        self.componentTwoHeld = NO;
        [self.componentTwoButton setTitle:@"⚪️" forState:UIControlStateNormal];
    }
    else
    {
        self.componentTwoHeld = YES;
        [self.componentTwoButton setTitle:@"🔵" forState:UIControlStateNormal];
    }
}

- (IBAction)componentThreeButtonTapped:(id)sender
{
    if (self.justWon)
    {
        [self holdingSlotsError];
        
        return;
    }
    if (self.componentThreeHeld)
    {
        self.componentThreeHeld = NO;
        [self.componentThreeButton setTitle:@"⚪️" forState:UIControlStateNormal];
    }
    else
    {
        self.componentThreeHeld = YES;
        [self.componentThreeButton setTitle:@"🔵" forState:UIControlStateNormal];
    }
}

- (void)holdingSlotsError
{
    self.notificationOneLabel.text = @"You can't hold slots";
    self.notificationTwoLabel.text = @"when you've just won.";
    
    [self showHiddenNotifcationLabels];
}

- (IBAction)cashOutButtonTapped:(id)sender
{
    [self.delegate AMYSlotsGameViewController:self didCashOut:self.tickets];
}

/*
 Spin the Fruit! (title)
 Spin to win tickets!
 
 Tickets are on the line as you spin to match emoji fruit. Win big when you get two in a row, and tenfold with three in a row! The more rare the fruit, the better the prize; the elusive lucky clover and diamond yield the highest ticket amounts.
 
 Play offline!
 
 No actual money involved.
 
 Inspired by a lab from the Flatiron School.
 */

/*
 Potential prizes: 🦄🐴🐙🐠🐢🐡🐬🐲🦀🐔🐷🦁🐶🐱🐹🐰🐻🐨🐯🐼🐮🐥🐗🐺🐒🐌
 Also: 🐚🌰🌷🌹🌻🌺🌼🌸💐🍄🎍🌳🌿🌲🍁☂️🍈
 Hmm... I wonder if I can add new fruits to the wheel spin.  Like, for special prices, you can spin "special" wheels--like ones with a better chance of getting a diamond (and therefore a better payout), or ones that are like only made up of apples and eggplants, which means you have a very good chance of winning a middling payout.  Like, you can have ONE spin (if you pay 50 tickets) of getting a 50% chance of winning at least 50 tickets.  Or if you pay 1000 tickets, you get ONE spin of a wheel with a ton more clovers and diamonds, although the rest of them are all cherries or grapes, so you can either win 10,000 tickets as a result, or 5.  That might be fun.
 Maybe too I can add different fruits.  Like, replace one of them with a melon, which is worth a special amount of tickets if won.  I don't know.  That might be kind of complicated though.
 I still like the ticket voucher prize--you can display those as well, and it would be a badge of honor if you have like 300 and haven't needed to use any because you've been so fortunate with your winnings.  But you can turn those in for 100 more tickets, maybe.
 Every prize on your shelf is worth some number of tickets.   They can be tiered.  So blowfish would be worth a lot less than tropical fish.  Cat a lot less than tiger.  Horse a whole lot less than unicorn (which should be the most expensive one in the game).  And each of those can be exchanged, just like the vouchers, for half the tickets they're worth.  That way if you blow through your voucher, you still have an opportunity to turn in your prize and get more tickets to play.
 */

@end
