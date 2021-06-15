//
//  rectangleShape.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "RectangleShape.h"
#import "Game.h"


@implementation RectangleShape

@synthesize blockIsDead;

+(id) rectangleShapeWithGame:(Game*)game createBlockAt:(cpVect)pt 
                       width:(int)w 
                      height:(int)h 
                        mass:(int)mass
{
	return [[[self alloc] initWithGame:game createBlockAt:(cpVect)pt 
                                 width:(int)w 
                                height:(int)h 
                                  mass:(int)mass] autorelease];
}

+(id) rectangleShapeWithGame:(Game*)game shape:(cpShape*)shape
{
	return [[[self alloc] initWithGame:game shape:shape] autorelease];	
}

-(id) initWithGame:(Game*)game createBlockAt:(cpVect)pt 
             width:(int)w 
            height:(int)h 
              mass:(int)mass
{    
    cpShape *shape = [game.spaceManager addRectAt:pt mass:mass width:w height:h rotation:0];
	shape->collision_type = kBlockCollisionType;
    
    shape->layers = 1;  shape->u = 5.0;  shape->e = 0.0;    
    
	return [self initWithGame:game shape:shape];    
}

-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{        
    if (stage == DAY_TIME_SUBURB) {
        
        [super initWithShape:shape file: @"WoodRectangleBlock.png"];
        
        //Daytime block color
        self.color = ccc3(0, 255, 0);
    }
    
    else if (stage == NIGHT_TIME_SUBURB) {
    
        [super initWithShape:shape file: @"WoodRectangleBlockGlow.png"];
        
        //Glow in the dark block color
        self.color = ccc3 (152, 251, 152);
    }
        
    iceBlock = [CCSprite spriteWithFile:@"StandUpBlockIce.png"];
    [self addChild: iceBlock z:100];
    
    if (stage == DAY_TIME_SUBURB) {
        
        iceBlock.position = ccp(iceBlock.position.x + 24, iceBlock.position.y + 75);
    }
    
    else if (stage == NIGHT_TIME_SUBURB) {
    
     //   iceBlock.position = ccp(iceBlock.position.x + 55, iceBlock.position.y + 110);
        iceBlock.position = ccp(iceBlock.position.x + 27, iceBlock.position.y + 75);
    }
    
    
    iceBlock.visible = NO;
    
    shape->u = 10.0;  shape->e = 0.4;   
    
    //Set the block's layer depending on whether it's 1st player's block or 2nd player's block
    if (self.position.x > 250) {
        
        self.shape->layers = 1;
    }
    
    if (self.position.x < 250) {
        
        self.shape->layers = 2;
    }
    
    blockIsDead = NO;
    
    _blockIsBurning = NO;
    _blockIsIce = NO;
        
    _game = game;
    
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
	
	//Handle collisions
	shape->collision_type = kBlockCollisionType;
	    
	return self;
}

-(void) whitePoof
{
    [(Game*)_game whitePoof: self.position];        
}

-(void) addDamage:(int)damage1
{
 
        //Equation used to find coordinate of vertices of a polygon of n number of sides.
/*       for (int i = 0; i < 20; i++) {
        NSLog(@"%f %f",8 * cos(2 * M_PI * i / 20), 8 * sin(2 * M_PI * i / 20));
    }
 */  
    
    if (stage == DAY_TIME_SUBURB) {
    
        _damage1 += damage1;
        
        red = _damage1;
        green = 255 - red;
        blue = 0;
    }
    
    else if (stage == NIGHT_TIME_SUBURB) {
    
        _damage1 += damage1;
        
        if (30 + _damage1 <= 240) {
        
            red = 30 + _damage1;
        }
        
        else {
            
            red = 240;
        }
        
        if (251 - _damage1 >= 25) {
            
            green = 251 - _damage1;
        }
        
        else {
            
            green = 25;
        }
        
        blue = 20;
    }
    
    if (!_blockIsIce) {
        
        [self setColor: ccc3(red, green, blue)];
    }
    
  //  NSLog (@"_damage1 = %i, red = %i, green = %i, blue = %i", _damage1, red, green, blue);
	
	if (_damage1 > 255 && blockIsDead == NO)
	{		
        iceBlock.visible = NO;
        
        if (isPlayer1) {
        
            if (self.position.x > 300) {
            
                destroyedBlocksInARow1 = destroyedBlocksInARow1 + 1;
                NSLog (@"destroyedBlocksInARow1 = %i", destroyedBlocksInARow1);
                
                if (destroyedBlocksInARow1 == 2) {
                    
                    [(Game*)_game playDestroyedBlockBonusSound1];
                    [(Game*)_game bonusPointPopUp: self.position];
                    bonusPoints1 = bonusPoints1 + 1;
                    
                    [(Game*)_game sendBonusPointsPlayer1];
                }
                
                else if (destroyedBlocksInARow1 >= 3) {
                    
                    [(Game*)_game playDestroyedBlockBonusSound2];
                    [(Game*)_game bonusPointPopUp: self.position];
                    bonusPoints1 = bonusPoints1 + 2;
                    
                    [(Game*)_game sendBonusPointsPlayer1];
                }
            }
        }
        
        else if (!isPlayer1) {
            
            if (self.position.x < 300) {
            
                destroyedBlocksInARow2 = destroyedBlocksInARow2 + 1;
                
                if (destroyedBlocksInARow2 == 2) {
                    
                    [(Game*)_game playDestroyedBlockBonusSound1];
                    [(Game*)_game bonusPointPopUp: self.position];
                    bonusPoints2 = bonusPoints2 + 1;
                    
                    [(Game*)_game sendBonusPointsPlayer2];
                }
                
                else if (destroyedBlocksInARow2 >= 3) {
                    
                    [(Game*)_game playDestroyedBlockBonusSound2];
                    [(Game*)_game bonusPointPopUp: self.position];
                    bonusPoints2 = bonusPoints2 + 2;
                    
                    [(Game*)_game sendBonusPointsPlayer2];
                }
            }
        }
        
        
        blockIsDead = YES;
                
        self.shape->layers = 4;
        self.opacity = 0;
           
        if (_blockIsBurning == NO && _blockIsIce == NO) {
            CDXAudioNode *audioBreakingSplintery = [[self children] objectAtIndex:1];
            [audioBreakingSplintery play];
            
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(whitePoof)], [CCDelayTime actionWithDuration:0.5], [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        }
        
        else if (_blockIsBurning == YES && _blockIsIce == NO) {
            
            CCSprite *sprite = self.shape->data;   
            audioBlockCrumblingFromFire = [[sprite children] objectAtIndex:4];
            [audioBlockCrumblingFromFire play];
            
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(whitePoof)], [CCDelayTime actionWithDuration:1.3], [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
            
            audioBlockOnFire = [[sprite children] objectAtIndex:3];
            [audioBlockOnFire play];
            
            [flame runAction: [CCFadeOut actionWithDuration: 0.7]];
        }
        
        else if (_blockIsIce == YES) {
            
            CDXAudioNode *audioIceBlockBeingDestroyed = [[self children] objectAtIndex:5];
            [audioIceBlockBeingDestroyed play];
            
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(whitePoof)], [CCDelayTime actionWithDuration:0.5], [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        }
	}
}

-(void) setDamage: (int)damage1
{
    _damage1 = damage1;
}

-(void) addDamageToBurningBlock
{
    [self addDamage:2];
}

- (void) burningBlock
{
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(addDamageToBurningBlock)], [CCDelayTime actionWithDuration: 0.8], [CCCallFunc actionWithTarget:self selector:@selector(addDamageToBurningBlock)], [CCDelayTime actionWithDuration: 0.8], nil]]];

    CCSprite *sprite = self.shape->data;   
    audioBlockOnFire = [[sprite children] objectAtIndex:3];
    audioBlockOnFire.playMode = kAudioNodeLoop;
    [audioBlockOnFire play];
    
     if (_blockIsBurning == NO) {
        
         _blockIsBurning = YES; 
         
        flame = [CCSprite spriteWithFile: @"marbleflame.png"];
         [self addChild: flame z:6];
                
        flame.scaleX = 2.0; 
        flame.scaleY = 6.5;
        flame.opacity = 180;
         
         if (stage == DAY_TIME_SUBURB) {
             
             flame.position = ccp(25, 75);
         }
         
         else if (stage == NIGHT_TIME_SUBURB) { 
         
             flame.position = ccp(28, 85);
         }
        
        [flame runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCFlipX actionWithFlipX: YES], [CCDelayTime actionWithDuration: 0.1], [CCFlipX actionWithFlipX: NO], [CCDelayTime actionWithDuration: 0.1], nil]]];
     }
}

-(void) setBlockColorToIceBlue
{
    //[self setColor: ccc3(30, 144, 225)];
    [self setColor: ccWHITE];
}

-(void) setIcyBlocksFrictionToZero
{
    self.shape->u = 0.1;
}

-(void) icyBlock
{
    _blockIsIce = YES;
    
    iceBlock.visible = YES;
    
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setIcyBlocksFrictionToZero)],[CCCallFunc actionWithTarget:self selector:@selector(setBlockColorToIceBlue)],[CCDelayTime actionWithDuration:0.75], [CCCallFuncND actionWithTarget:self selector:@selector(setDamage:) data:(void*)254], nil]];
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
