//
//  gerty2.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"
#import "Bomb2.h"
#import "CDXAudioNode.h"


BOOL gertyPlayer2Alive;


@class Game;

CDXAudioNode *audioGerty2BeingDestroyed;
BOOL gerty2SlotAnimationIsRunning;

@interface Gerty2 : cpCCSprite 
{
	Game *_game;
	BOOL _countDown;
    BOOL _currentlyHappyGerty;;
    BOOL _currentlySadGerty;
    BOOL _currentlyUncertainGerty;
    BOOL _currentlyCryingGerty;
    BOOL _currentlyBigSmileGerty;
    BOOL _currentlyPensiveGerty;
    CCSprite *happyGerty;
    CCSprite *sadGerty;
    CCSprite *uncertainGerty;
    CCSprite *cryingGerty;
    CCSprite *bigSmileGerty;
    CCSprite *pensiveGerty;
    CCSprite *crackedScreen;
    CCSprite *blackMarbleGlowInTamagachi;
    CCSprite *blueMarbleGlowInTamagachi;
    CCSprite *greenMarbleGlowInTamagachi;
    CCSprite *redMarbleGlowInTamagachi;
    CCSprite *yellowMarbleGlowInTamagachi;
}

+(id) gerty2WithGame:(Game*)game;
+(id) gerty2WithGame:(Game*)game shape:(cpShape*)shape;
-(id) initWithGame:(Game*)game;
-(id) initWithGame:(Game*)game shape:(cpShape*)shape;

-(void) blowup;
-(void) sadGertyFace;
-(void) happyGertyFace;
-(void) cryingGertyFace;
-(void) pensiveGertyFace;
-(void) bigSmileGertyFace;
-(void) chooseComputerGertyColor;
-(void) setComputerGertyColor;
-(void) startMarbleSlotMachine;
-(void) allMarblesInSlotMachineShouldBeInvisible;
-(void) displaySelectedSlotMachineBombOnGerty;
-(void) makeAllSlotMarblesNotVisible;
-(void) displayNoMarbles;
-(void) makeAllSlotMarblesNotVisibleAndGertyFaces;
-(void) setAllSlotMarblesToNotVisible;


@end
