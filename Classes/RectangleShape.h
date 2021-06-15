//
//  RectangleShape.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"
#import "CDXAudioNode.h"
#import "CDXAudioNodeBlocks.h"


@class Game;


@interface RectangleShape : cpCCSprite 
{
	Game *_game;
    int _damage1;
    int red;
    int green;
    int blue;
	BOOL _countDown;
    BOOL blockIsDead;
    CCSprite *flame;
    BOOL _blockIsBurning;
    BOOL _blockIsIce;
    CCSprite *iceBlock;
}

@property BOOL blockIsDead;


+(id) rectangleShapeWithGame:(Game*)game createBlockAt:(cpVect)pt width:(int)w height:(int)h mass:(int)mass;
+(id) rectangleShapeWithGame:(Game*)game shape:(cpShape*)shape;
-(id) initWithGame:(Game*)game createBlockAt:(cpVect)pt width:(int)w height:(int)h mass:(int)mass;
-(id) initWithGame:(Game*)game shape:(cpShape*)shape;

-(void) addDamage:(int)damage1;
-(void) blowup;
-(void) burningBlock;
-(void) addDamageToBurningBlock;
-(void) icyBlock;


@end
