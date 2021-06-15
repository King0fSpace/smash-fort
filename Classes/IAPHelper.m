//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "IAPHelper.h"
#import "Game.h"


@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            NSLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
                        
    }
    return self;
}

- (void)requestProducts {
    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results...");   
    self.products = response.products;
    self.request = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {    
    // TODO: Record the transaction on the server side...    
}

- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    //[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    
    if ([productIdentifier isEqualToString: @"com.sm.smashfort.1000batterypointsnoads1"]) {
         
        [[SimpleAudioEngine sharedEngine] playEffect:@"LevelUpAngelsSound.wav"];          
        
        //Update player1Level label
        player1Level = player1Level + 1000;
        [player1LevelLabelMainMenu setString: [NSString stringWithFormat:@"Z-%i", player1Level]];

        //increase player1marblesUnlocked
        player1MarblesUnlocked = player1MarblesUnlocked + 10;
        [prefs setInteger:player1MarblesUnlocked forKey:@"player1MarblesUnlocked"];
        
        //Turn off ads
        if (showAds) {
            
            //adWhirlView.hidden = YES;
            //[adWhirlView ignoreNewAdRequests];
        }
        
        prefs = [NSUserDefaults standardUserDefaults];
        showAds = NO;
        [prefs setBool:NO forKey:@"showAds"];
        
        [prefs synchronize];
        
        //[(Game*)_game gertyMainMenuUpdateLights];
        [player1LevelLabelMainMenu setString:[NSString stringWithFormat:@"Z-%i", player1Level]];
        [player1ExperiencePointsLabelMainMenu setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints]];
        
        NSLog(@"Running gertyMainMenuUpdateLights");
        
        if (player1MarblesUnlocked == 0) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(255, 192, 203);
            ledBulb3MainMenu.color = ccc3(255, 192, 203);
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);
            
            
            ledLight2MainMenu.opacity = 0;
            ledLight3MainMenu.opacity = 0;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
            NSLog (@"only green LED should show");
        }
        
        else if (player1MarblesUnlocked == 1) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccc3(255, 192, 203);
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);  
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 0;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked == 2) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203); 
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked == 3) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccGRAY;
            ledBulb5MainMenu.color = ccc3(255, 192, 203); 
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 255;
            ledLight5MainMenu.opacity = 0;        
        }
        
        else if (player1MarblesUnlocked >= 4) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccGRAY;
            ledBulb5MainMenu.color = ccc3(250 , 250, 170); 
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 255;
            ledLight5MainMenu.opacity = 255;      
        }

        
        NSLog (@"Should be adding 1,000 points!");
    }
    
    else if ([productIdentifier isEqualToString: @"com.sm.smashfort.500batterypointsnoads"]) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"LevelUpAngelsSound.wav"];          
        
        //Update player1Level label
        player1Level = player1Level + 500;
        [player1LevelLabelMainMenu setString: [NSString stringWithFormat:@"Z-%i", player1Level]];
        
        //increase player1marblesUnlocked
        player1MarblesUnlocked = player1MarblesUnlocked + 10;
        [prefs setInteger:player1MarblesUnlocked forKey:@"player1MarblesUnlocked"];
        
        //Turn off ads
        if (showAds) {
            
            //adWhirlView.hidden = YES;
            //[adWhirlView ignoreNewAdRequests];
        }
        
        prefs = [NSUserDefaults standardUserDefaults];
        showAds = NO;
        [prefs setBool:NO forKey:@"showAds"];
        
        [prefs synchronize];
        //[(Game*)_game gertyMainMenuUpdateLights];
        [player1LevelLabelMainMenu setString:[NSString stringWithFormat:@"Z-%i", player1Level]];
        [player1ExperiencePointsLabelMainMenu setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints]];
                
        NSLog(@"Running gertyMainMenuUpdateLights");
        
        if (player1MarblesUnlocked == 0) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(255, 192, 203);
            ledBulb3MainMenu.color = ccc3(255, 192, 203);
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);
            
            
            ledLight2MainMenu.opacity = 0;
            ledLight3MainMenu.opacity = 0;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
            NSLog (@"only green LED should show");
        }
        
        else if (player1MarblesUnlocked == 1) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccc3(255, 192, 203);
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);  
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 0;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked == 2) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203); 
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked == 3) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccGRAY;
            ledBulb5MainMenu.color = ccc3(255, 192, 203); 
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 255;
            ledLight5MainMenu.opacity = 0;        
        }
        
        else if (player1MarblesUnlocked >= 4) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccGRAY;
            ledBulb5MainMenu.color = ccc3(250 , 250, 170); 
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 255;
            ledLight5MainMenu.opacity = 255;      
        }

        
        NSLog (@"Should be adding 500 points!");
    }
    
    else if ([productIdentifier isEqualToString: @"com.sm.smashfort.100batterypointsnoads"]) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"LevelUpAngelsSound.wav"];
        
        //Update player1Level label
        player1Level = player1Level + 100;
        [player1LevelLabelMainMenu setString: [NSString stringWithFormat:@"Z-%i", player1Level]];
        
        //increase player1marblesUnlocked
        player1MarblesUnlocked = player1MarblesUnlocked + 1;
        [prefs setInteger:player1MarblesUnlocked forKey:@"player1MarblesUnlocked"];
        
        //Turn off ads
        if (showAds) {
            
            //adWhirlView.hidden = YES;
            //[adWhirlView ignoreNewAdRequests];
        }
        
        prefs = [NSUserDefaults standardUserDefaults];
        showAds = NO;
        [prefs setBool:NO forKey:@"showAds"];
        
        [prefs synchronize];
        //[(Game*)_game gertyMainMenuUpdateLights];
        [player1LevelLabelMainMenu setString:[NSString stringWithFormat:@"Z-%i", player1Level]];
        [player1ExperiencePointsLabelMainMenu setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints]];
        
        NSLog(@"Running gertyMainMenuUpdateLights");
        
        if (player1MarblesUnlocked == 0) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(255, 192, 203);
            ledBulb3MainMenu.color = ccc3(255, 192, 203);
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);
            
            
            ledLight2MainMenu.opacity = 0;
            ledLight3MainMenu.opacity = 0;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
            NSLog (@"only green LED should show");
        }
        
        else if (player1MarblesUnlocked == 1) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccc3(255, 192, 203);
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 0;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked == 2) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccc3(255, 192, 203);
            ledBulb5MainMenu.color = ccc3(255, 192, 203);
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 0;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked == 3) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccGRAY;
            ledBulb5MainMenu.color = ccc3(255, 192, 203);
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 255;
            ledLight5MainMenu.opacity = 0;
        }
        
        else if (player1MarblesUnlocked >= 4) {
            
            ledBulb1MainMenu.color = ccGREEN;
            ledBulb2MainMenu.color = ccc3(30, 144, 255);
            ledBulb3MainMenu.color = ccRED;
            ledBulb4MainMenu.color = ccGRAY;
            ledBulb5MainMenu.color = ccc3(250 , 250, 170);
            
            ledLight2MainMenu.opacity = 255;
            ledLight3MainMenu.opacity = 255;
            ledLight4MainMenu.opacity = 255;
            ledLight5MainMenu.opacity = 255;
        }
        
        NSLog (@"Should be adding 100 points!");
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:difficultyLevel forKey:@"difficultyLevel"];
    [prefs setInteger:computerExperiencePoints forKey:@"computerExperiencePoints"];
    [prefs setInteger:player1MarblesUnlocked forKey:@"player1MarblesUnlocked"];
    [prefs setInteger:player1ExperiencePoints forKey:@"player1ExperiencePoints"];
    [prefs setInteger:player1Level forKey:@"player1Level"];
    
    [(Game*)_game saveGameSettings];

    [prefs synchronize];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [(Game*)_game saveGameSettings];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    NSLog(@"Buying %@...", productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

@end
