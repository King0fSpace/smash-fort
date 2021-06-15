//
//  MainMenuScene.h
//  GrenadeGame
//
//  Created by Long Le on 12/29/11.
//  Copyright (c) 2011 Laguna Beach Unified School District. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "Gerty.h"
#import "GCHelper.h"
#import "GrenadeGameAppDelegate.h"


BOOL bPAD;

BOOL showAds;

CCLabelBMFont *player1LevelLabel;
CCLabelBMFont *player1ExperiencePointsLabel;

CCLabelBMFont *player1LevelLabelMainMenu;
CCLabelBMFont *player1ExperiencePointsLabelMainMenu;

int player1LevelForLabel;
int player1ExperiencePointsForLabel;

int player1Level;
int player1ExperiencePoints;
int player1LevelMultiplayerValue;
int player1ExperiencePointsMultiplayerValue;

int player2Level;
int player2ExperiencePoints;
int player2LevelMultiplayerValue;
int player2ExperiencePointsMultiplayerValue;


BOOL restartingLevel;
BOOL continuePlayingLevelFromVictoryScreen;

CCSprite *ledLight1;
CCSprite *ledLight2;
CCSprite *ledLight3;
CCSprite *ledLight4;
CCSprite *ledLight5;
CCSprite *ledBulb1;
CCSprite *ledBulb2;
CCSprite *ledBulb3;
CCSprite *ledBulb4;
CCSprite *ledBulb5;


@interface MainMenuScene : CCLayer {
    
    Game *_game;
    CCSprite *carpet; 
}

@property(nonatomic, assign) BOOL bannerIsVisible;



+(id) scene;
-(void) gerty;
-(void) woodBlock;
-(void) loadGameSettings;



@end
