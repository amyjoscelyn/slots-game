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
    //I should probably double the amount of fruits in the array here... maybe even triple them?  Chances of winning right now are pretty great. I won nearly 15000 with only a little bit of thought and about one minute of time
    
    //💎 1  1
    //🍀 2  2
    //🍆 4  4
    //🍊 5  6
    //🍎 6  8
    //🍉 7  11
    //🍌 8  14
    //🍇 9  18
    //🍒 10 22 ?????? how would this affect the chances of winning??? I feel like more would only mean you'd win more.  That might be faulty logic.  It might also be a distant goal to have the wheel spin longer (and to add sound).  Casinos make their slot machines with a lot more unique symbols, don't they?  That's how their winning chances stay low.  I don't have room in my rules grid to add more fruits.
    //I miiiiight be able to slow down the animation--have it run at half speed, or something.  I'll look into that sometime.
    //This should be the next build kind of feature.  The amounts of tickets don't really matter until I have some way to persist them, and to use them on something else.
    
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
        
        [self showHiddenNotificationLabels];
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

- (void)showHiddenNotificationLabels
{
    self.notificationOneLabel.hidden = NO;
    self.notificationTwoLabel.hidden = NO;
}

- (void)hideNotificationLabels
{
//    NSLog(@"notification labels hidden");
    self.notificationOneLabel.hidden = YES;
    self.notificationTwoLabel.hidden = YES;
}

- (void)spinTheFruits
{
    [self hideNotificationLabels];
    
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
    
    if (playerWinsALot)
    {
        NSUInteger winnings = [self playersWinningsWithFruitsInARow:3];
        
        [self populateViewWithWinnings:winnings];
        
        [self unholdAllComponents:YES];
    }
    else if (playerWinsALittle)
    {
        NSUInteger winnings = [self playersWinningsWithFruitsInARow:2];
        
        [self populateViewWithWinnings:winnings];
        
        [self unholdAllComponents:NO];
    }
    else
    {
        self.justWon = NO;
        
        self.notificationOneLabel.text = @"";
        self.notificationTwoLabel.text = @"";
    }
    self.totalTicketWinnings.text = [NSString stringWithFormat:@"Total Tickets Won: %li", self.amountOfTicketsWon];
    self.currentTicketAmount.text = [NSString stringWithFormat:@"Your Tickets: %li", self.tickets];
    
    [self showHiddenNotificationLabels];
}

- (void)populateViewWithWinnings:(NSUInteger)winnings
{
    NSString *title = @"";
    NSString *message = @"";
    
    self.amountOfTicketsWon += winnings;
    self.tickets += winnings;
    self.justWon = YES;
    
    title = [NSString stringWithFormat:@"You've won %lu tickets!", winnings];
    message = @"Wanna play again?";
    
    self.notificationOneLabel.text = title;
    self.notificationTwoLabel.text = message;
}

- (void)unholdAllComponents:(BOOL)clearAllComponents
{
    [self.componentOneButton setTitle:@"⚪️" forState:UIControlStateNormal];
    [self.componentTwoButton setTitle:@"⚪️" forState:UIControlStateNormal];
    
    if (clearAllComponents)
    {
        [self.componentThreeButton setTitle:@"⚪️" forState:UIControlStateNormal];
        self.componentThreeHeld = NO;
    }
    self.componentOneHeld = NO;
    self.componentTwoHeld = NO;
    //sometimes when you try to manually unhold a column, it triggers but doesn't change state until you tap it again.  wonder why?
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
        winnings = [self winningsFromMatchedFruit:rowOne];
        winnings *= 10;
    }
    else if (amountOfFruitsInARow == 2)
    {
        winnings = [self winningsFromMatchedFruit:rowOne];
    }
    return winnings;
}

- (NSUInteger)winningsFromMatchedFruit:(NSUInteger)rowOne
{
    NSUInteger winnings;
    
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
    
    [self showHiddenNotificationLabels];
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
 Also? 👹👺💀👽🤖(masks) 👒🎩👑 (hats) 🎒💍🕶👓🌂 (accessories) 🏆🏅 (trophes) 🎨🖌🎮🎲🃏🔮⚗📜🗺🛎🔦🔖 (activities and toys, like a deck of cards) 💰💎🔑🗝🛍 (stuff?) 🎁 (surprise?) 🎊🎉 (congratulations!) 🎭🎐🎈🎀🛡 (decorations)  💝 (box of chocolates)
 cheap: 🔖🎈🗺🎀
 moderate: 🛎👓
 expensive: 💍🕶
 most sought after: 👑💰💎🛡
 Hmm... I wonder if I can add new fruits to the wheel spin.  Like, for special prices, you can spin "special" wheels--like ones with a better chance of getting a diamond (and therefore a better payout), or ones that are like only made up of apples and eggplants, which means you have a very good chance of winning a middling payout.  Like, you can have ONE spin (if you pay 50 tickets) of getting a 50% chance of winning at least 50 tickets.  Or if you pay 1000 tickets, you get ONE spin of a wheel with a ton more clovers and diamonds, although the rest of them are all cherries or grapes, so you can either win 10,000 tickets as a result, or 5.  That might be fun.
 Maybe too I can add different fruits.  Like, replace one of them with a melon, which is worth a special amount of tickets if won.  I don't know.  That might be kind of complicated though.
 I still like the ticket voucher prize--you can display those as well, and it would be a badge of honor if you have like 300 and haven't needed to use any because you've been so fortunate with your winnings.  But you can turn those in for 100 more tickets, maybe.
 Every prize on your shelf is worth some number of tickets.   They can be tiered.  So blowfish would be worth a lot less than tropical fish.  Cat a lot less than tiger.  Horse a whole lot less than unicorn (which should be the most expensive one in the game).  And each of those can be exchanged, just like the vouchers, for half the tickets they're worth.  That way if you blow through your voucher, you still have an opportunity to turn in your prize and get more tickets to play.
 */

@end
