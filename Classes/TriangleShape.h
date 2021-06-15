//
//  TriangleShape.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"

@class Game;

@interface TriangleShape : cpShapeNode 
{
	Game *_game;
    int _damage1;
    int red;
    int green;
    int blue;
	BOOL _countDown;
}

@property (readwrite) int red;
@property (readwrite) int green;
@property (readwrite) int blue;

+(id) triangleShapeWithGame:(Game*)game;
+(id) triangleShapeWithGame:(Game*)game shape:(cpShape*)shape;
-(id) initWithGame:(Game*)game;
-(id) initWithGame:(Game*)game shape:(cpShape*)shape;

-(void) addDamage:(int)damage1;
-(void) blowup;

@end
