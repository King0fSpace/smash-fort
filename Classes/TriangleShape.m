//
//  TriangleShape.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "TriangleShape.h"
#import "Game.h"

@implementation TriangleShape

@synthesize red;
@synthesize green;
@synthesize blue;


+(id) triangleShapeWithGame:(Game*)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

+(id) triangleShapeWithGame:(Game*)game shape:(cpShape*)shape
{
	return [[[self alloc] initWithGame:game shape:shape] autorelease];	
}

-(id) initWithGame:(Game*)game
{
	cpShape *shape = [game.spaceManager addPolyAt:cpvzero mass:200 rotation:0 numPoints:3 points:ccp(-35,0), ccp(0,35), ccp(35,0), nil];

	return [self initWithGame:game shape:shape];    
}

-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{        
    [super initWithShape: shape];
    
    self.color = ccc3(0, 255, 0);
        
    _game = game;
    		
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
	
	//Handle collisions
	shape->collision_type = kTriangleBlockCollisionType;
	
	return self;
}

-(void) addDamage:(int)damage1
{
	_damage1 += damage1;
    
    red = _damage1;
    green = 255 - red;
    blue = 0;
        
    //ccc3(red, green, blue)
    [self setColor: ccc3(red, green, blue)];
    
	
	if (_damage1 > 255)
	{		
		CCSprite *poof = [CCSprite spriteWithFile:@"poof.png"];
		[_game addChild:poof z:10];
		poof.scale = .1;
		poof.position = self.position;
		id s = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:1 scale:1]];
		id d = [CCDelayTime actionWithDuration:.3];
		id f = [CCFadeOut actionWithDuration:.7];
		
		[poof runAction:[CCSequence actions:s,d,f,nil]];
		[self removeFromParentAndCleanup:YES];
	}
}

-(void) blowup
{
	/*[self.spaceManager applyLinearExplosionAt:self.position radius:100 maxForce:4500];
	
	CCParticleSun *explosion = [[[CCParticleSun alloc] initWithTotalParticles:60] autorelease];
	explosion.position = self.position;
	explosion.duration = .5;
	explosion.speed = 40;
	explosion.autoRemoveOnFinish = YES;
	explosion.blendAdditive = NO;
	[_game addChild:explosion];
	[_game removeChild:self cleanup:YES];
     */
}

@end
