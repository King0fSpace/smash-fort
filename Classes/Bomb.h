//
//  Bomb.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"
#import "CDXAudioNode.h"
#import "Gerty.h"

BOOL player2BombInPlay;
BOOL player1BombInPlay;
BOOL player1BombIsAirborne;
BOOL player1BombExists;
BOOL player1HasGreenBall;
BOOL player1HasRedBall;
BOOL player1HasBlueBall;
BOOL player1HasYellowBall;
BOOL player1HasBlackBall;
int player1MarbleColor;
int randomNumber;
int randomNumber1;

@class Game;

@interface Bomb : cpCCSprite 
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
-(void) player1BombZapped;


@end
