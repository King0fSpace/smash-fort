//
//  Bomb.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"

BOOL player2BombInPlay;
BOOL player1BombInPlay;
BOOL player2BombIsAirborne;
BOOL player2BombExists;
BOOL player2HasGreenBall;
BOOL player2HasRedBall;
BOOL player2HasBlueBall;
BOOL player2HasYellowBall;
BOOL player2HasBlackBall;
int player2MarbleColor;
int randomNumber;
int randomNumber1;


@class Game;

@interface Bomb2 : cpCCSprite 
{
	Game *_game;
	BOOL _countDown;
}

+(id) bombWithGame:(Game*)game;
+(id) bombWithGame:(Game*)game shape:(cpShape*)shape;
-(id) initWithGame:(Game*)game;
-(id) initWithGame:(Game*)game shape:(cpShape*)shape;

-(void) startCountDown;
-(void) blowup;
-(void) player2BombZapped;


@end
