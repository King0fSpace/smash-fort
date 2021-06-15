//
//  Ninja.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "Ninja.h"
#import "Game.h"

CCSprite *poof;

@implementation Ninja

+(id) ninjaWithGame:(Game*)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

+(id) ninjaWithGame:(Game*)game shape:(cpShape*)shape
{
	return [[[self alloc] initWithGame:game shape:shape] autorelease];	
}

-(id) initWithGame:(Game*)game
{
//	cpShape *shape = [game.spaceManager addCircleAt:cpvzero mass:50 radius:9];
    
    cpShape *shape = [game.spaceManager addPolyAt:cpvzero mass:50 rotation:4 numPoints: 4 points:cpv(-5,-5), cpv(-5,5), cpv(5,5), cpv(5,-5)];
    
    shape->layers = 1;
    
	return [self initWithGame:game shape:shape];
}

-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{
	[super initWithShape:shape file:@"elephant.png"];

    poof = [CCSprite spriteWithFile:@"poof.png"];
    [self addChild:poof z:10];
    poof.opacity = 0.0;

	_game = game;   shape->layers = 1;
	
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
	
	//Handle collisions
	shape->collision_type = kNinjaCollisionType;
	
	return self;
}

-(void) addDamage:(int)damage
{
	_damage += damage;
	
	if (_damage > 2)
	{
	//	[_game enemyKilled];
		
		//CCSprite *poof = [CCSprite spriteWithFile:@"poof.png"];
		//[_game addChild:poof z:10];
        
/*        self.opacity = 0.0;
        self.shape->layers = 2;
        cpBodyResetForces(self.shape->body);
        poof.opacity = 150.0;
		poof.scale = .1;
        //self.position = [self convertToWorldSpace: _game.position];
		//poof.position = self.position;
        
        
		id s = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:1 scale:1]];
		id d = [CCDelayTime actionWithDuration:.3];
		id f = [CCFadeOut actionWithDuration:.7];
        id removeFromParent = [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
        
		[poof runAction:[CCSequence actions:d, s,d,f, removeFromParent, nil]];
 */    
		[self removeFromParentAndCleanup:YES];
	}
}

@end
