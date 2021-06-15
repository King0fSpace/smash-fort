//
//  MKiCloudSync.m
//
//  Created by Mugunth Kumar on 11/20//11.
//  Modified by Alexsander Akers on 1/4/12.
//  
//  Copyright (C) 2011-2020 by Steinlogic
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "MKiCloudSync.h"

@interface MKiCloudSync ()

+ (void) pushToICloud;
+ (void) pullFromICloud: (NSNotification *) note;
+ (void) clean;

@end

@implementation MKiCloudSync

+ (BOOL) start
{
	if ([NSUbiquitousKeyValueStore class] && [NSUbiquitousKeyValueStore defaultStore])
	{
        //  FORCE PULL
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
        NSDictionary *dict = [store dictionaryRepresentation];
        NSLog(@"!!! UPDATING FROM ICLOUD IN START METHOD!!! %@", dict);
        
        //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        prefs = [NSUserDefaults standardUserDefaults];
        /*[dict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
            
            [prefs setObject: obj forKey: key];
        }];
         */
                
        //The following algorithm determines the local aggregate rank and experience points and compares it to the iCloud's aggregate rank and experience points
        
        //iCloud player1ExperiencePoints value
        NSNumber *player1ExperiencePointsNumber = [dict valueForKey:@"player1ExperiencePoints"];
        //iCloud player1Level value
        NSNumber *player1LevelNumber = [dict valueForKey:@"player1Level"];
        //iCloud player1MarblesUnlocked
        NSNumber *player1MarblesUnlockedNumber = [dict valueForKey:@"player1MarblesUnlocked"];
        NSNumber *showAdsNumber = [dict valueForKey:@"showAds"];
        
        NSLog (@"player1Level Value From iCloud = %i", [player1LevelNumber intValue]);
        NSLog (@"player1ExperiencePoints Value From iCloud = %i", [player1ExperiencePointsNumber intValue]);
        NSLog (@"player1MarblesUnlockedNumber Value From iCloud = %i", [player1MarblesUnlockedNumber intValue]);
        
      /*
        //iCloud computer difficulty level and experience points in NSNumber format
        NSNumber *computerDifficultyLevelNumber = [dict valueForKey:@"difficultyLevel"];
        NSNumber *computerExperiencePointsNumber = [dict valueForKey:@"computerExperiencePoints"];
        
        //iCloud computer difficultyLevel and Experience Points raw int format
        int computerDifficultyLeveliCloudValue = [computerDifficultyLevelNumber intValue];
        int computerExperiencePointsiCloudValue = [computerExperiencePointsNumber intValue];
       */ 
        
        //Player1 level and experience points iCloud Values
        int player1ExperiencePointsiCloudValue = [player1ExperiencePointsNumber intValue];
        int player1LeveliCloudValue = [player1LevelNumber intValue];
        int player1MarblesUnlockediCloudValue = [player1MarblesUnlockedNumber intValue];
        BOOL showAdsiCloudValue = [showAdsNumber intValue];
        
        //Player1 level and experience points Local Values
        int player1ExperiencePointsLocalValue = [prefs integerForKey:@"player1ExperiencePoints"]; 
        int player1LevelLocalValue = [prefs integerForKey:@"player1Level"];
        int player1MarblesUnlockedLocalValue = [prefs integerForKey:@"player1MarblesUnlocked"];
        //int showAdsLocalValue = [prefs boolForKey:@"showAds"];
        
        //Player1 level and experience points added together, iCloud Value
        int player1LevelAndExperiencePointsSumiCloudValue = player1LeveliCloudValue*100 + player1ExperiencePointsiCloudValue;
        //Player1 level and experience points added together, Local Value
        int player1LevelAndExperiencePointsSumLocalValue = player1LevelLocalValue*100 + player1ExperiencePointsLocalValue;
        
        
        if (player1LevelAndExperiencePointsSumiCloudValue > player1LevelAndExperiencePointsSumLocalValue) {
            
            [prefs setInteger:player1ExperiencePointsiCloudValue forKey:@"player1ExperiencePoints"];
            [prefs setInteger:player1LeveliCloudValue forKey:@"player1Level"];
         //   [prefs setInteger:computerDifficultyLeveliCloudValue forKey:@"difficultyLevel"];
         //   [prefs setInteger:computerExperiencePointsiCloudValue forKey:@"computerExperiencePoints"];
        }
        
        if (player1MarblesUnlockediCloudValue > player1MarblesUnlockedLocalValue) {
            
            [prefs setInteger:player1MarblesUnlockediCloudValue forKey:@"player1MarblesUnlocked"];
        }
        
        if (showAdsiCloudValue == NO) {
            
            NSLog (@"In start method, set showAds to %i", [showAdsNumber intValue]);
            [prefs setBool: showAdsiCloudValue forKey:@"showAds"];
        }
        
        //If stage == 0, that means neither DAY_TIME or NIGHT_TIME has not been set for prefs.  In this case, set the level to NIGHT_TIME.  Also, assume that the player has never seen the tutorial and set inGameTutorialHasAlreadyBeenPlayedOnce to NO
        NSNumber *stageNumber = [dict valueForKey: @"stage"];
        NSNumber *stageNumberPrefs = [prefs valueForKey: @"stage"];
        int stageNumberiCloudValue = [stageNumber intValue];
        
        if ([stageNumber intValue] == 0 && [stageNumberPrefs intValue] == 0) {
            
            NSLog (@"Stage equals 0");
            
            [prefs setInteger: NIGHT_TIME_SUBURB forKey: @"stage"];
            [prefs setBool: NO forKey:@"inGameTutorialHasAlreadyBeenPlayedOnce"];
        }
        
        if ([stageNumber intValue] != 0 || [stageNumberPrefs intValue] != 0) {
            
            [prefs setInteger: stageNumberiCloudValue forKey:@"stage"];
        }
        
        //If iCloud value for player1ExperiencePoints comes back as 0 for whatever reason, set all prefs to default values
        else if (player1ExperiencePointsiCloudValue == 0 && player1LeveliCloudValue == 0) {
            
            [prefs setBool: NO forKey:@"inGameTutorialHasAlreadyBeenPlayedOnce"];
            [prefs setInteger:TAMAGACHI_1_RED forKey: @"tamagachi1Color"];
            [prefs setBool:YES forKey:@"showAds"];
            [prefs setInteger:10 forKey:@"computerExperiencePoints"];
            [prefs setInteger:0 forKey:@"difficultyLevel"];
            [prefs setInteger:0 forKey:@"player1MarblesUnlocked"];
            [prefs setInteger:97 forKey:@"player1ExperiencePoints"];
            [prefs setInteger:100 forKey:@"player1Level"];
            [prefs setBool:YES forKey:@"showPointingFingerForGertyMainMenuLightBulbs"];
            [prefs setBool:YES forKey:@"showPointingFingerForGertyMainMenuTamagachi"];
            
            tamagachi1Color = [prefs integerForKey:@"tamagachi1Color"];
            showAds = [prefs boolForKey:@"showAds"];
            computerExperiencePoints = [prefs integerForKey:@"computerExperiencePoints"];
            difficultyLevel = [prefs integerForKey:@"difficultyLevel"];
            player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
            player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
            player1Level = [prefs integerForKey:@"player1Level"];
            NSLog (@"computerExperiencePoints = %i", computerExperiencePoints);
        }
        
        else {
            
            NSLog (@"Local value is larger than iCloud value during iCloud Pull, hence, local device will not overwrite its local level and experience points values with iCloud's");
        }
        
        player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
        player1Level = [prefs integerForKey:@"player1Level"];
        
        NSNumber *tamagachi1ColorNumber = [dict valueForKey:@"tamagachi1Color"];
        tamagachi1Color = [tamagachi1ColorNumber intValue];
        
        NSLog (@"player1Level Value From Local = %i", [prefs integerForKey:@"player1Level"]);
        NSLog (@"player1ExperiencePoints Value From Local = %i", [prefs integerForKey:@"player1ExperiencePoints"]);
        
        //DEBUG: Force showAds to YES
        [prefs setBool:YES forKey:@"showAds"];
        
        [prefs synchronize];
        
        //  FORCE PUSH
        [MKiCloudSync pushToICloud];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kMKiCloudSyncNotification object: nil];
        //
        
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pullFromICloud:) name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification object: store];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pushToICloud) name: NSUserDefaultsDidChangeNotification object: nil];
		        
		return YES;
	}
	
	return NO;
}
+ (void) stop
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

+ (void) pushToICloud
{
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	NSMutableDictionary *persistentDomain = [NSMutableDictionary dictionaryWithDictionary: [[NSUserDefaults standardUserDefaults] persistentDomainForName: identifier]];
    
    //  EXCL. SPECIAL KEYS LIKE DEVICE-SPECIFIC ONES
    [persistentDomain removeObjectsForKeys: [NSArray arrayWithObjects: @"iCloudSync", nil]];
    
    
    NSLog(@"!!! UPDATING TO ICLOUD in pushToICloud method !!!");
	
	NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
	
    NSDictionary *dict = [store dictionaryRepresentation];
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    prefs = [NSUserDefaults standardUserDefaults];

    /*[persistentDomain enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        
        

        [store setObject: obj forKey: key];
        
	}];
	*/
    
    
    //The following algorithm determines the local aggregate rank and experience points and compares it to the iCloud's aggregate rank and experience points
    
    //iCloud player1ExperiencePoints NSNumber value
    NSNumber *player1ExperiencePointsNumber = [dict valueForKey:@"player1ExperiencePoints"];
    //iCloud player1Level NSNumber value
    NSNumber *player1LevelNumber = [dict valueForKey:@"player1Level"];
    NSNumber *player1MarblesUnlockedNumber = [dict valueForKey:@"player1MarblesUnlocked"];
    NSNumber *showAdsNumber = [dict valueForKey:@"showAds"];
    
    //Local player1ExperiencePoints NSNumber value
    NSNumber *player1ExperiencePointsNumberLocal = [prefs valueForKey:@"player1ExperiencePoints"];
    //Local player1Level NSNumber value
    NSNumber *player1LevelNumberLocal = [prefs valueForKey:@"player1Level"];
    NSNumber *player1MarblesUnlockedNumberLocal = [prefs valueForKey:@"player1MarblesUnlocked"];
    NSNumber *showAdsNumberLocal = [prefs valueForKey:@"showAds"];
    
    //Computer level and experience points
   // NSNumber *computerDifficultyLevel = [prefs valueForKey:@"difficultyLevel"];
   // NSNumber *computerExperiencePoints = [prefs valueForKey:@"computerExperiencePoints"];
    
    NSLog (@"player1Level Value From iCloud = %i", [player1LevelNumber intValue]);
    NSLog (@"player1ExperiencePoints Value From iCloud = %i", [player1ExperiencePointsNumber intValue]);
    
    NSLog (@"player1Level Value From Local = %i", [prefs integerForKey:@"player1Level"]);
    NSLog (@"player1ExperiencePoints Value From Local = %i", [prefs integerForKey:@"player1ExperiencePoints"]);
    
    //Player1 level and experience points iCloud Values
    int player1ExperiencePointsiCloudValue = [player1ExperiencePointsNumber intValue];
    int player1LeveliCloudValue = [player1LevelNumber intValue];
    int player1MarblesUnlockediCloudValue = [player1MarblesUnlockedNumber intValue];
   // BOOL showAdsiCloudValue = [showAdsNumber intValue];
    
    //Player1 level and experience points Local Values
    int player1ExperiencePointsLocalValue = [prefs integerForKey:@"player1ExperiencePoints"]; 
    int player1LevelLocalValue = [prefs integerForKey:@"player1Level"];
    int player1MarblesUnlockedLocalValue = [prefs integerForKey:@"player1MarblesUnlocked"];
    
    //Player1 level and experience points added together, iCloud Value
    int player1LevelAndExperiencePointsSumiCloudValue = player1LeveliCloudValue*100 + player1ExperiencePointsiCloudValue;
    //Player1 level and experience points added together, Local Value
    int player1LevelAndExperiencePointsSumLocalValue = player1LevelLocalValue*100 + player1ExperiencePointsLocalValue;
    
    if (player1LevelAndExperiencePointsSumiCloudValue < player1LevelAndExperiencePointsSumLocalValue) {
        
        [store setObject:player1ExperiencePointsNumberLocal forKey:@"player1ExperiencePoints"];
        [store setObject:player1LevelNumberLocal forKey:@"player1Level"];
     //   [store setObject:computerDifficultyLevel forKey:@"difficultyLevel"];
     //   [store setObject:computerExperiencePoints forKey:@"computerExperiencePoints"];
    }
    
    if (player1MarblesUnlockediCloudValue < player1MarblesUnlockedLocalValue) {
        
        [store setObject:player1MarblesUnlockedNumberLocal forKey:@"player1MarblesUnlocked"];
    }
    
    else {
        
        NSLog (@"Local value is less than than iCloud value during iCloud Push, hence, Local device will not push its lower level and experience points values to iCloud");
    }
    
    if (showAds == NO) {
        
        NSLog (@"Settings iCloud's showAds value to NO");
        [store setObject:showAdsNumberLocal forKey: @"showAds"];
    }
    
    NSNumber *stageNumberLocal = [prefs valueForKey: @"stage"];
    [store setObject:stageNumberLocal forKey: @"stage"];
    NSNumber *tamagachi1ColorNumberLocal = [prefs valueForKey: @"tamagachi1Color"];
    [store setObject:tamagachi1ColorNumberLocal forKey:@"tamagachi1Color"];
    
    //DEBUG: Force showAds to YES
    NSNumber *yesNumber = [NSNumber numberWithBool:YES];
    [store setObject: yesNumber forKey: @"showAds"];
    
    /*
     //This is the old algorithm which didn't take into account the player's level
    NSNumber *player1ExperiencePointsNumber = [dict valueForKey:@"player1ExperiencePoints"];
    
    NSLog (@"player1ExperiencePoints Value From iCloud = %i", [player1ExperiencePointsNumber intValue]);
    NSLog (@"player1ExperiencePoints Value From Local = %i", [prefs integerForKey:@"player1ExperiencePoints"]);
    
    int player1ExperiencePointsiCloudValue = [player1ExperiencePointsNumber intValue];
    
    int player1ExperiencePointsLocalValue = [prefs integerForKey:@"player1ExperiencePoints"]; 
    
    if (player1ExperiencePointsiCloudValue > player1ExperiencePointsLocalValue) {
        
        [store setObject: player1ExperiencePointsNumber forKey:@"player1ExperiencePoints"];
    }
    
    else {
        
        NSLog (@"Local value is larger than iCloud value during iCloud Push");
    }
    */
	[store synchronize];
}

+ (void) pullFromICloud: (NSNotification *) note
{
	[[NSNotificationCenter defaultCenter] removeObserver: self name: NSUserDefaultsDidChangeNotification object: nil];
	
	//NSUbiquitousKeyValueStore *store = note.object;
	
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    NSDictionary *dict = [store dictionaryRepresentation];
    
	//NSArray *changedKeys = [note.userInfo objectForKey: NSUbiquitousKeyValueStoreChangedKeysKey];
    NSLog(@"!!! UPDATING FROM ICLOUD IN pullFromICloud Method !!! %@", dict);
	
   // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    prefs = [NSUserDefaults standardUserDefaults];

    NSNumber *player1ExperiencePointsNumber = [dict valueForKey:@"player1ExperiencePoints"];
    //iCloud player1Level value
    NSNumber *player1LevelNumber = [dict valueForKey:@"player1Level"];
  /*
    //iCloud computer difficulty level and experience points in NSNumber format
    NSNumber *computerDifficultyLevelNumber = [dict valueForKey:@"difficultyLevel"];
    NSNumber *computerExperiencePointsNumber = [dict valueForKey:@"computerExperiencePoints"];
    
    //iCloud computer difficultyLevel and Experience Points raw int format
    int computerDifficultyLeveliCloudValue = [computerDifficultyLevelNumber intValue];
    int computerExperiencePointsiCloudValue = [computerExperiencePointsNumber intValue];
   */ 
    NSLog (@"player1Level Value From iCloud = %i", [player1LevelNumber intValue]);
    NSLog (@"player1ExperiencePoints Value From iCloud = %i", [player1ExperiencePointsNumber intValue]);
 
    //Player1 level and experience points iCloud Values
    int player1ExperiencePointsiCloudValue = [player1ExperiencePointsNumber intValue];
    int player1LeveliCloudValue = [player1LevelNumber intValue];
    
    //Player1 level and experience points Local Values
    int player1ExperiencePointsLocalValue = [prefs integerForKey:@"player1ExperiencePoints"]; 
    int player1LevelLocalValue = [prefs integerForKey:@"player1Level"];
    
    //Player1 level and experience points added together, iCloud Value
    int player1LevelAndExperiencePointsSumiCloudValue = player1LeveliCloudValue*100 + player1ExperiencePointsiCloudValue;
    //Player1 level and experience points added together, Local Value
    int player1LevelAndExperiencePointsSumLocalValue = player1LevelLocalValue*100 + player1ExperiencePointsLocalValue;

    
    if (player1LevelAndExperiencePointsSumiCloudValue > player1LevelAndExperiencePointsSumLocalValue) {
        
        [prefs setInteger:player1ExperiencePointsiCloudValue forKey:@"player1ExperiencePoints"];
        [prefs setInteger:player1LeveliCloudValue forKey:@"player1Level"];
    //    [prefs setInteger:computerDifficultyLeveliCloudValue forKey:@"difficultyLevel"];
    //    [prefs setInteger:computerExperiencePointsiCloudValue forKey:@"computerExperiencePoints"];
    }
    
    //If stage == 0, that means neither DAY_TIME or NIGHT_TIME has not been set for prefs.  In this case, set the level to NIGHT_TIME.  Also, assume that the player has never seen the tutorial and set inGameTutorialHasAlreadyBeenPlayedOnce to NO
    NSNumber *stageNumber = [dict valueForKey: @"stage"];
    NSNumber *stageNumberPrefs = [prefs valueForKey: @"stage"];
    int stageNumberiCloudValue = [stageNumber intValue];
    if ([stageNumber intValue] == 0 && [stageNumberPrefs intValue] == 0) {
        
        NSLog (@"Stage equals 0");
        
        [prefs setInteger: NIGHT_TIME_SUBURB forKey: @"stage"];
        [prefs setBool: NO forKey:@"inGameTutorialHasAlreadyBeenPlayedOnce"];
    }
    
    if ([stageNumber intValue] != 0 || [stageNumberPrefs intValue] != 0) {
        
        [prefs setInteger: stageNumberiCloudValue forKey:@"stage"];
    }
    
    //If iCloud value for player1ExperiencePoints comes back as 0 for whatever reason, set all prefs to default values
    if (player1ExperiencePointsiCloudValue == 0) {
        
        [prefs setBool: NO forKey:@"inGameTutorialHasAlreadyBeenPlayedOnce"];
        [prefs setInteger:TAMAGACHI_1_RED forKey: @"tamagachi1Color"];
        [prefs setBool:YES forKey:@"showAds"];
        [prefs setInteger:10 forKey:@"computerExperiencePoints"];
        [prefs setInteger:0 forKey:@"difficultyLevel"];
        [prefs setInteger:0 forKey:@"player1MarblesUnlocked"];
        [prefs setInteger:97 forKey:@"player1ExperiencePoints"];
        [prefs setInteger:100 forKey:@"player1Level"];
        [prefs setBool:YES forKey:@"showPointingFingerForGertyMainMenuLightBulbs"];
        [prefs setBool:YES forKey:@"showPointingFingerForGertyMainMenuTamagachi"];
        
        tamagachi1Color = [prefs integerForKey:@"tamagachi1Color"];
        showAds = [prefs boolForKey:@"showAds"];
        computerExperiencePoints = [prefs integerForKey:@"computerExperiencePoints"];
        difficultyLevel = [prefs integerForKey:@"difficultyLevel"];
        player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
        player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
        player1Level = [prefs integerForKey:@"player1Level"];
        NSLog (@"computerExperiencePoints = %i", computerExperiencePoints);
    }
    
    else {
        
        NSLog (@"Local value is larger than iCloud value during iCloud Pull, hence, local device will not overwrite its local level and experience points values with iCloud's");
    }
    
    player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
    player1Level = [prefs integerForKey:@"player1Level"];
    NSNumber *tamagachi1ColorNumber = [dict valueForKey:@"tamagachi1Color"];
    tamagachi1Color = [tamagachi1ColorNumber intValue];

    //DEBUG: Force showAds to YES
    [prefs setBool:YES forKey:@"showAds"];
    
    NSLog (@"player1Level Value From Local = %i", [prefs integerForKey:@"player1Level"]);
    NSLog (@"player1ExperiencePoints Value From Local = %i", [prefs integerForKey:@"player1ExperiencePoints"]);
    
    /*
    [changedKeys enumerateObjectsUsingBlock: ^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        id obj = [store objectForKey: key];
        
		[prefs setObject: obj forKey: key];
	}];
    
	[prefs synchronize];
	*/
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pushToICloud) name: NSUserDefaultsDidChangeNotification object: nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName: kMKiCloudSyncNotification object: nil];
}

+ (void) clean {
    [self stop];
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
	NSDictionary *dict = [store dictionaryRepresentation];
    [dict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        //  NON-NIL TO KEEP KEY, NIL TO LOOSE KEY
		[store setObject: @"" forKey: key];
        //
	}];
    
    [store synchronize];
    NSLog(@"!!! CLEANING ICLOUD !!! %@", [store dictionaryRepresentation]);
}

+ (void)dealloc {
    //  DOES ANYONE KNOW HOW LONG THIS IS KEPT ALIVE?
    //  SOMETIMES I FELT LIKE THE CLASS STOPPED WORKING,
    //  HOWEVER AFTER IMPLEMENTING THIS,
    //  THE LOG NEVER APPEARED FOR ME.
    NSLog(@"!!! FOR DEBUGGING PURPOSES ONLY !!!");
    [super dealloc];
    //
}

@end