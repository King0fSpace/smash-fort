//
//  GrenadeGameAppDelegate.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/19/11.
//  Copyright Mobile Bros 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCHelper.h"
#import "Game.h"
#import "MKiCloudSync.h"
#import "RootViewController.h"


BOOL firstTimeAtMenu;
BOOL firstTimeLoadingGameScene;
BOOL isIPhoneIPod;
BOOL userIsOnFastDevice;


@class RootViewController;

@interface GrenadeGameAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    Game *_game;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

@end
