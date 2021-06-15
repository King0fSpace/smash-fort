//
//  gerty2.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "gerty2.h"
#import "Game.h"


@implementation Gerty2

+(id) gerty2WithGame:(Game*)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

+(id) gerty2WithGame:(Game*)game shape:(cpShape*)shape
{
	return [[[self alloc] initWithGame:game shape:shape] autorelease];	
}

-(id) initWithGame:(Game*)game
{
	cpShape *shape = [game.spaceManager addPolyAt:cpvzero mass:60 rotation:0 numPoints:4 points:ccp(-15,-14.1), ccp(-15,15), ccp(15,15), ccp(15,-14.1)];
    
    /*    cpShape *shape = [game.spaceManager addPolyAt:cpvzero mass:STATIC_MASS rotation:4 numPoints:20 points:cpv(8,0), cpv(7.608452,-2.472136), cpv(6.472136,-4.702282), cpv(4.702282,-6.472136), cpv(2.472136,-7.608452), cpv(0,-8), cpv(-2.472136,-7.608452), cpv(-4.702282,-6.472136), cpv(-6.472136,-4.702282), cpv(-7.608452,-2.472136), cpv(-8,0), cpv(-7.608452,2.472136), cpv(-6.472136,4.702282), cpv(-4.702282,6.472136), cpv(-2.472136,7.608452), cpv(0,8), cpv(2.472136,7.608452), cpv(4.702282,6.472136), cpv(6.472136,4.702282), cpv(7.608452,2.472136)];*/
    
	return [self initWithGame:game shape:shape];   
    
    shape->layers = 2;  shape->u = 10.0;  shape->e = 0.0;  shape->body->m = 100;  
}


-(void) chooseComputerGertyColor 
{    
    if (difficultyLevel == 0) {
        
        if (computerExperiencePoints == 10) {
            
            computerGertyColor = ccYELLOW;
            NSLog (@"computerGertyColor is ccYELLOW");
        }
        
        if (computerExperiencePoints == 20) {
         
            computerGertyColor = ccc3(255, 215, 0);
            NSLog (@"computerGertyColor is ccc3(255, 215, 0)");
        }
        
        if (computerExperiencePoints == 30) {
            
            computerGertyColor = ccc3(218, 165, 32);
        }
        
        if (computerExperiencePoints == 40) {
            
            computerGertyColor = ccc3(255, 165, 0);
        }
        
        if (computerExperiencePoints == 50) {
         
            computerGertyColor = ccc3(255, 140, 0);
        }
        
        if (computerExperiencePoints == 60) {
            
            computerGertyColor = ccc3(255, 99, 71);
        }
        
        if (computerExperiencePoints == 70) {
                
            computerGertyColor = ccRED;
        }
        
        if (computerExperiencePoints == 80) {
            
            computerGertyColor = ccc3(186, 85, 211);
        }
        
        if (computerExperiencePoints == 90) {
            
            computerGertyColor = ccc3(138, 43, 226);
        }
    }
}

-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{
    if (tamagachi2Color == TAMAGACHI_2_RED && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_PINK && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-200 pink.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_GREEN && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-500 green.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_YELLOW && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-500 yellow.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_ORANGE && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-500 orange.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_LIGHTPURPLE && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-1000 purple.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_PURPLE && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-1000 maroon.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_BLUE && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-1000 blue.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_WHITE && !isSinglePlayer) {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-2000 white.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_BLACK || isSinglePlayer){
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-2000 black.png"];
    }
    
    else {
        
        [self initWithShape:shape spriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    happyGerty = [CCSprite spriteWithFile: @"happygerty.png"];
    sadGerty = [CCSprite spriteWithFile: @"sadgerty.png"];
    uncertainGerty = [CCSprite spriteWithFile: @"uncertaingerty.png"];
    cryingGerty = [CCSprite spriteWithFile: @"cryinggerty.png"];
    bigSmileGerty = [CCSprite spriteWithFile: @"bigsmilegerty.png"];
    pensiveGerty = [CCSprite spriteWithFile: @"pensivegerty.png"];
    crackedScreen = [CCSprite spriteWithFile: @"CrackedScreen.png"];
    
    if (stage == DAY_TIME_SUBURB) {
        
        //Glowing marbles
        blackMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"blackmarble.png"];
        blueMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"bluemarble.png"];
        greenMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"greenmarble.png"];
        redMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"redmarble.png"];
        yellowMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"yellowmarble.png"];
    }
    
    else if (stage == NIGHT_TIME_SUBURB) {
        
        //Glowing marbles
        blackMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"Black Marble glow.png"];
        blackMarbleGlowInTamagachi.color = ccc3(220, 220, 220);
        blueMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"Blue Marble glow.png"];
        blueMarbleGlowInTamagachi.color = ccc3(152, 251, 152);
        greenMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"Green Marble glow.png"];
        greenMarbleGlowInTamagachi.color = ccc3(152, 251, 152);
        redMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"Red Marble glow.png"];
        redMarbleGlowInTamagachi.color = ccc3(255, 192, 203);
        yellowMarbleGlowInTamagachi = [CCSprite spriteWithFile: @"Yellow Marble glow.png"];
        yellowMarbleGlowInTamagachi.color = ccc3(255, 255, 240);
    }
    
    [self addChild: happyGerty];
    [self addChild: sadGerty];
    [self addChild: uncertainGerty];
    [self addChild: cryingGerty];
    [self addChild: bigSmileGerty];
    [self addChild: pensiveGerty];
    [self addChild: crackedScreen];
    [self addChild: blackMarbleGlowInTamagachi];
    [self addChild: blueMarbleGlowInTamagachi];
    [self addChild: greenMarbleGlowInTamagachi];
    [self addChild: redMarbleGlowInTamagachi];
    [self addChild: yellowMarbleGlowInTamagachi];
        
    happyGerty.anchorPoint = ccp(0.5, 0.5);
    sadGerty.anchorPoint = ccp(0.5, 0.5);
    uncertainGerty.anchorPoint = ccp(0.5, 0.5);
    cryingGerty.anchorPoint = ccp(0.5, 0.5);
    bigSmileGerty.anchorPoint = ccp(0.5, 0.5);
    pensiveGerty.anchorPoint = ccp(0.5, 0.5);
    crackedScreen.anchorPoint = ccp(0.5, 0.5);
    blackMarbleGlowInTamagachi.anchorPoint = ccp(0.5, 0.5);
    blueMarbleGlowInTamagachi.anchorPoint = ccp(0.5, 0.5);
    greenMarbleGlowInTamagachi.anchorPoint = ccp(0.5, 0.5);
    redMarbleGlowInTamagachi.anchorPoint = ccp(0.5, 0.5);
    yellowMarbleGlowInTamagachi.anchorPoint = ccp(0.5, 0.5);

    
    crackedScreen.scaleX = 1.17;
    crackedScreen.scaleY = 0.78;
    happyGerty.scaleX = 0.6;
    happyGerty.scaleY = 0.55;
    sadGerty.scaleX = 0.6;
    sadGerty.scaleY = 0.55;
    uncertainGerty.scaleX = 0.6;
    uncertainGerty.scaleY = 0.55;
    cryingGerty.scaleX = 0.6;
    cryingGerty.scaleY = 0.55;
    bigSmileGerty.scaleX = 0.6;
    bigSmileGerty.scaleY = 0.55;
    pensiveGerty.scaleX = 0.6;
    pensiveGerty.scaleY = 0.55;
    
    blackMarbleGlowInTamagachi.scaleX = 1.105;
    blackMarbleGlowInTamagachi.scaleY = 0.935;
    
    blueMarbleGlowInTamagachi.scaleX = 1.105;
    blueMarbleGlowInTamagachi.scaleY = 0.935;
    
    greenMarbleGlowInTamagachi.scaleX = 1.105;
    greenMarbleGlowInTamagachi.scaleY = 0.935;
    
    redMarbleGlowInTamagachi.scaleX = 1.105;
    redMarbleGlowInTamagachi.scaleY = 0.935;
    
    yellowMarbleGlowInTamagachi.scaleX = 1.105;
    yellowMarbleGlowInTamagachi.scaleY = 0.935;
    
    
    [crackedScreen runAction: [CCFadeOut actionWithDuration: 0.0]];
    [sadGerty runAction: [CCFadeOut actionWithDuration: 0.0]];
    [happyGerty runAction: [CCFadeOut actionWithDuration: 0.0]];
    [cryingGerty runAction: [CCFadeOut actionWithDuration: 0.0]];
    [bigSmileGerty runAction: [CCFadeOut actionWithDuration: 0.0]];
    [pensiveGerty runAction: [CCFadeOut actionWithDuration: 0.0]];
    [uncertainGerty runAction: [CCFadeIn actionWithDuration: 0.0]];
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
    
    gertyPlayer2Alive = YES;
    _currentlyUncertainGerty = YES;
    _currentlySadGerty = NO;
    _currentlyHappyGerty = NO;
    _currentlyCryingGerty = NO;
    _currentlyBigSmileGerty = NO;
    _currentlyPensiveGerty = NO;
    
    if (!isSinglePlayer) {
    
        happyGerty.position = ccp(68, 55);
        sadGerty.position = ccp(68, 55);
        uncertainGerty.position = ccp(68, 55);
        cryingGerty.position = ccp(68, 55);
        bigSmileGerty.position = ccp(68, 55);
        pensiveGerty.position = ccp(68, 55);
        crackedScreen.position = ccp(68, 55);
        
        blackMarbleGlowInTamagachi.position = ccp(66, 52);
        blueMarbleGlowInTamagachi.position = ccp(68, 52);
        greenMarbleGlowInTamagachi.position = ccp(68, 52);
        redMarbleGlowInTamagachi.position = ccp(68, 52);
        yellowMarbleGlowInTamagachi.position = ccp(68, 52);
    }
    
    else if (isSinglePlayer) {
        
        happyGerty.position = ccp([self contentSize].width/2, [self contentSize].height/2);
        sadGerty.position = ccp([self contentSize].width/2, [self contentSize].height/2);
        uncertainGerty.position = ccp([self contentSize].width/2, [self contentSize].height/2);
        cryingGerty.position = ccp([self contentSize].width/2, [self contentSize].height/2);
        bigSmileGerty.position = ccp([self contentSize].width/2, [self contentSize].height/2);
        pensiveGerty.position = ccp([self contentSize].width/2, [self contentSize].height/2);
        crackedScreen.position = ccp([self contentSize].width/2, [self contentSize].height/2);
    }

    
    shape->layers = 1;  shape->u = 5.0;  shape->e = 0.0;  
    
	_game = game;
	
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
	
	//Handle collisions
	shape->collision_type = kGerty2CollisionType;
	
	return self;
}

-(void) setAllSlotMarblesToNotVisible
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
}

-(void) startMarbleSlotMachine
{
    gerty2SlotAnimationIsRunning = YES;
    
    if (player1Winner || player2Winner) {
        
        blackMarbleGlowInTamagachi.visible = NO;
        blueMarbleGlowInTamagachi.visible = NO;
        greenMarbleGlowInTamagachi.visible = NO;
        redMarbleGlowInTamagachi.visible = NO;
        yellowMarbleGlowInTamagachi.visible = NO;
    }
    
    else if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == NO) {
        
        randomNumber1 = arc4random()%101;
        
        //Green marble should have an 80% chance of being chosen of tesla1 is not glowing
        if (randomNumber1 >= 0 && randomNumber1 <= 79) {
            
            blackMarbleGlowInTamagachi.visible = NO;
            blueMarbleGlowInTamagachi.visible = NO;
            greenMarbleGlowInTamagachi.visible = YES;
            redMarbleGlowInTamagachi.visible = NO;
            yellowMarbleGlowInTamagachi.visible = NO;
        }
        
        else if (randomNumber1 >= 80 && randomNumber1 <= 100) {
            
            if (player1MarblesUnlocked == 0) {
                
                blackMarbleGlowInTamagachi.visible = NO;
                blueMarbleGlowInTamagachi.visible = NO;
                greenMarbleGlowInTamagachi.visible = YES;
                redMarbleGlowInTamagachi.visible = NO;
                yellowMarbleGlowInTamagachi.visible = NO;
            }
            
            else if (player1MarblesUnlocked == 1) {
                
                blackMarbleGlowInTamagachi.visible = NO;
                blueMarbleGlowInTamagachi.visible = YES;
                greenMarbleGlowInTamagachi.visible = NO;
                redMarbleGlowInTamagachi.visible = NO;
                yellowMarbleGlowInTamagachi.visible = NO;
            }
            
            else if (player1MarblesUnlocked == 2) {
                
                randomNumber = arc4random()%2;
                
                if (randomNumber == 0) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = YES;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
                
                else if (randomNumber == 1) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = YES;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
            }
            
            else if (player1MarblesUnlocked == 3) {
                
                randomNumber = arc4random()%3;
                
                if (randomNumber == 0) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = YES;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
                
                else if (randomNumber == 1) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = YES;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }     
                
                else if (randomNumber == 2) {
                    
                    blackMarbleGlowInTamagachi.visible = YES;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }   
            }
            
            else if (player1MarblesUnlocked >= 4) {
                
                randomNumber = arc4random()%4;
                
                if (randomNumber == 0) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = YES;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
                
                else if (randomNumber == 1) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = YES;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }     
                
                else if (randomNumber == 2) {
                    
                    blackMarbleGlowInTamagachi.visible = YES;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }   
                
                else if (randomNumber == 3) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = YES;
                } 
            }
        }
    }
    
    else if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == YES) {
        
        randomNumber1 = arc4random()%101;
        
        //Green marble should have an 20% chance of being chosen of tesla1 is not glowing
        if (randomNumber1 >= 0 && randomNumber1 <= 19) {
            
            blackMarbleGlowInTamagachi.visible = NO;
            blueMarbleGlowInTamagachi.visible = NO;
            greenMarbleGlowInTamagachi.visible = YES;
            redMarbleGlowInTamagachi.visible = NO;
            yellowMarbleGlowInTamagachi.visible = NO;
        }
        
        else if (randomNumber1 >= 20 && randomNumber1 <= 100) {
            
            if (player1MarblesUnlocked == 0) {
                
                blackMarbleGlowInTamagachi.visible = NO;
                blueMarbleGlowInTamagachi.visible = NO;
                greenMarbleGlowInTamagachi.visible = YES;
                redMarbleGlowInTamagachi.visible = NO;
                yellowMarbleGlowInTamagachi.visible = NO;
            }
            
            else if (player1MarblesUnlocked == 1) {
                
                blackMarbleGlowInTamagachi.visible = NO;
                blueMarbleGlowInTamagachi.visible = YES;
                greenMarbleGlowInTamagachi.visible = NO;
                redMarbleGlowInTamagachi.visible = NO;
                yellowMarbleGlowInTamagachi.visible = NO;
            }
            
            else if (player1MarblesUnlocked == 2) {
                
                randomNumber = arc4random()%2;
                
                if (randomNumber == 0) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = YES;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
                
                else if (randomNumber == 1) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = YES;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
            }
            
            else if (player1MarblesUnlocked == 3) {
                
                randomNumber = arc4random()%3;
                
                if (randomNumber == 0) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = YES;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
                
                else if (randomNumber == 1) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = YES;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }     
                
                else if (randomNumber == 2) {
                    
                    blackMarbleGlowInTamagachi.visible = YES;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }   
            }
            
            else if (player1MarblesUnlocked >= 4) {
                
                randomNumber = arc4random()%4;
                
                if (randomNumber == 0) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = YES;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }
                
                else if (randomNumber == 1) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = YES;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }     
                
                else if (randomNumber == 2) {
                    
                    blackMarbleGlowInTamagachi.visible = YES;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = NO;
                }   
                
                else if (randomNumber == 3) {
                    
                    blackMarbleGlowInTamagachi.visible = NO;
                    blueMarbleGlowInTamagachi.visible = NO;
                    greenMarbleGlowInTamagachi.visible = NO;
                    redMarbleGlowInTamagachi.visible = NO;
                    yellowMarbleGlowInTamagachi.visible = YES;
                } 
            }
        }
    }
    
    //Allow the marble to be displayed for 0.15 seconds (0.2s pulled from CCSequence in Game.m) then blank it out for 0.5 seconds
    [blackMarbleGlowInTamagachi runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], nil]];
    [blueMarbleGlowInTamagachi runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], nil]];
    [greenMarbleGlowInTamagachi runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], nil]];
    [redMarbleGlowInTamagachi runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], nil]];
    [yellowMarbleGlowInTamagachi runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], nil]];
    
    
    /*if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == NO) {
     
     int marbleColorToDisplay = arc4random()%5;
     
     if (marbleColorToDisplay == 0) {
     
     blackMarbleGlowInTamagachi.visible = YES;
     blueMarbleGlowInTamagachi.visible = NO;
     greenMarbleGlowInTamagachi.visible = NO;
     redMarbleGlowInTamagachi.visible = NO;
     yellowMarbleGlowInTamagachi.visible = NO;
     }
     
     else if (marbleColorToDisplay == 1) {
     
     blackMarbleGlowInTamagachi.visible = NO;
     blueMarbleGlowInTamagachi.visible = YES;
     greenMarbleGlowInTamagachi.visible = NO;
     redMarbleGlowInTamagachi.visible = NO;
     yellowMarbleGlowInTamagachi.visible = NO;
     }
     
     else if (marbleColorToDisplay == 2) {
     
     blackMarbleGlowInTamagachi.visible = NO;
     blueMarbleGlowInTamagachi.visible = NO;
     greenMarbleGlowInTamagachi.visible = YES;
     redMarbleGlowInTamagachi.visible = NO;
     yellowMarbleGlowInTamagachi.visible = NO;
     }
     
     else if (marbleColorToDisplay == 3) {
     
     blackMarbleGlowInTamagachi.visible = NO;
     blueMarbleGlowInTamagachi.visible = NO;
     greenMarbleGlowInTamagachi.visible = NO;
     redMarbleGlowInTamagachi.visible = YES;
     yellowMarbleGlowInTamagachi.visible = NO;
     }
     
     else if (marbleColorToDisplay == 4) {
     
     blackMarbleGlowInTamagachi.visible = NO;
     blueMarbleGlowInTamagachi.visible = NO;
     greenMarbleGlowInTamagachi.visible = NO;
     redMarbleGlowInTamagachi.visible = NO;
     yellowMarbleGlowInTamagachi.visible = YES;
     }
     }
     */
}

-(void) displayBlackMarble
{
    blackMarbleGlowInTamagachi.visible = YES;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
}

-(void) displayBlueMarble
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = YES;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
}

-(void) displayGreenMarble
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = YES;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
}

-(void) displayRedMarble
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = YES;
    yellowMarbleGlowInTamagachi.visible = NO;
}

-(void) displayYellowMarble
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = YES;
}

-(void) displayNoMarbles
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
    
    happyGerty.visible = YES;
    sadGerty.visible = YES;
    pensiveGerty.visible = YES;
    cryingGerty.visible = YES;
    bigSmileGerty.visible = YES;
    uncertainGerty.visible = YES;
}

-(void) makeAllSlotMarblesNotVisibleAndGertyFaces
{
    blackMarbleGlowInTamagachi.visible = NO;
    blueMarbleGlowInTamagachi.visible = NO;
    greenMarbleGlowInTamagachi.visible = NO;
    redMarbleGlowInTamagachi.visible = NO;
    yellowMarbleGlowInTamagachi.visible = NO;
    
    happyGerty.visible = NO;
    sadGerty.visible = NO;
    pensiveGerty.visible = NO;
    cryingGerty.visible = NO;
    bigSmileGerty.visible = NO;
    uncertainGerty.visible = NO;
}

-(void) displaySelectedSlotMachineBombOnGerty
{    
    NSLog (@"doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = %i", doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2);
    NSLog (@"randomNumber1 = %i", randomNumber1);
    NSLog (@"randomNumber = %i", randomNumber);
    
    if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == NO) {
        
        //Green marble should have an 80% chance of being chosen of tesla1 is not glowing
        if (randomNumber1 >= 0 && randomNumber1 <= 79) {
            
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], nil]];
        }
        
        else if (randomNumber1 >= 80 && randomNumber1 <= 100) {
            
            if (player1MarblesUnlocked == 0) {
                
                [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], nil]];
            }
            
            else if (player1MarblesUnlocked == 1) {
                
                [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
            }
            
            else if (player1MarblesUnlocked == 2) {
                
                randomNumber = arc4random()%2;
                
                if (randomNumber == 0) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
                }
                
                else if (randomNumber == 1) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], nil]];
                }
            }
            
            else if (player1MarblesUnlocked == 3) {
                
                randomNumber = arc4random()%3;
                
                if (randomNumber == 0) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
                }
                
                else if (randomNumber == 1) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], nil]];
                }     
                
                else if (randomNumber == 2) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], nil]];
                }   
            }
            
            else if (player1MarblesUnlocked >= 4) {
                
                randomNumber = arc4random()%4;
                
                if (randomNumber == 0) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
                }
                
                else if (randomNumber == 1) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], nil]];
                }     
                
                else if (randomNumber == 2) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], nil]];
                }   
                
                else if (randomNumber == 3) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], nil]];
                } 
            }
        }
    }
    
    else if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == YES) {
        
        //Green marble should have an 20% chance of being chosen of tesla1 is not glowing
        if (randomNumber1 >= 0 && randomNumber1 <= 19) {
            
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], nil]];
        }
        
        else if (randomNumber1 >= 20 && randomNumber1 <= 100) {
            
            if (player1MarblesUnlocked == 0) {
                
                [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayGreenMarble)], nil]];
            }
            
            else if (player1MarblesUnlocked == 1) {
                
                [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
            }
            
            else if (player1MarblesUnlocked == 2) {
                
                randomNumber = arc4random()%2;
                
                if (randomNumber == 0) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
                }
                
                else if (randomNumber == 1) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], nil]];
                }
            }
            
            else if (player1MarblesUnlocked == 3) {
                
                randomNumber = arc4random()%3;
                
                if (randomNumber == 0) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
                }
                
                else if (randomNumber == 1) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], nil]];
                }     
                
                else if (randomNumber == 2) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], nil]];
                }   
            }
            
            else if (player1MarblesUnlocked >= 4) {
                
                randomNumber = arc4random()%4;
                
                if (randomNumber == 0) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlueMarble)], nil]];
                }
                
                else if (randomNumber == 1) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayRedMarble)], nil]];
                }     
                
                else if (randomNumber == 2) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayBlackMarble)], nil]];
                }   
                
                else if (randomNumber == 3) {
                    
                    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(makeAllSlotMarblesNotVisibleAndGertyFaces)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(displayYellowMarble)], nil]];
                } 
            }
        }
    }
}




-(void) setComputerGertyColor
{
    if (isSinglePlayer == YES) {
        
        happyGerty.color = computerGertyColor;
        sadGerty.color = computerGertyColor;
        uncertainGerty.color = computerGertyColor;
        cryingGerty.color = computerGertyColor;
        bigSmileGerty.color = computerGertyColor;
        pensiveGerty.color = computerGertyColor;
    }
}

-(void) currentlyHappyGertyToNo
{
    _currentlyHappyGerty = NO;
}

-(void) currentlySadGertyToNo
{
    _currentlySadGerty = NO;
}

-(void) currentlyUncertainGertyToNo
{
    _currentlyUncertainGerty = NO;
}

-(void) currentlyCryingGertyToNo
{
    _currentlyCryingGerty = NO;
}

-(void) currentlyBigSmileGertyToNo
{
    _currentlyBigSmileGerty = NO;
}

-(void) currentlyPensiveGertyToNo
{
    _currentlyPensiveGerty = NO;
}

-(void) sadGertyPlaySound
{
    //CDXAudioNodeSlingShot *audioGertySad = [[self children] objectAtIndex:7];
    //[audioGertySad play]; 
}

-(void) pensiveGertyPlaySound
{
    //CDXAudioNodeSlingShot *audioGertyPensive = [[self children] objectAtIndex:8];
    //[audioGertyPensive play]; 
}

-(void) happyGertyPlaySound
{
    //CDXAudioNodeSlingShot *audioGertyHappy = [[self children] objectAtIndex:9];
    //[audioGertyHappy play]; 
}

-(void) sadGertyFace
{
    if (!_currentlySadGerty) {
        
        _currentlyPensiveGerty = NO;
        _currentlySadGerty = YES;
        
        int sadGertyFaceDelay = arc4random()%5;
        
        [pensiveGerty stopAllActions];
        
        [happyGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:sadGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [bigSmileGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:sadGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [cryingGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:sadGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [pensiveGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:sadGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [sadGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:sadGertyFaceDelay*0.1], [CCCallFunc actionWithTarget:self selector:@selector(sadGertyPlaySound)], [CCFadeIn actionWithDuration:0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeOut actionWithDuration: 0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:sadGertyFaceDelay*0.1], [CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.0],[CCCallFunc actionWithTarget:self selector:@selector(currentlySadGertyToNo)], nil]];    
    }
}

-(void) happyGertyFace
{
    if (!_currentlyHappyGerty && !_currentlySadGerty) {
        
        _currentlyPensiveGerty = NO;
        _currentlyHappyGerty = YES;
        
        int happyGertyFaceDelay = arc4random()%5;
        
        [pensiveGerty stopAllActions];
        
        [sadGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [bigSmileGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [cryingGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [pensiveGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [happyGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1], [CCFadeIn actionWithDuration:0.0], [CCCallFunc actionWithTarget:self selector:@selector(happyGertyPlaySound)], [CCDelayTime actionWithDuration: 5.0], [CCFadeOut actionWithDuration: 0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:happyGertyFaceDelay*0.1], [CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.0], [CCCallFunc actionWithTarget:self selector:@selector(currentlyHappyGertyToNo)], nil]];   
    }
}

-(void) bigSmileGertyFace
{
    if (!_currentlyBigSmileGerty) {
        
        _currentlyPensiveGerty = NO;
        _currentlyBigSmileGerty = YES;
        
        int bigSmileGertyFaceDelay = arc4random()%5;
        
        [pensiveGerty stopAllActions];
        
        [sadGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [cryingGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [pensiveGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [happyGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [bigSmileGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1], [CCFadeIn actionWithDuration:0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeOut actionWithDuration: 0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:bigSmileGertyFaceDelay*0.1], [CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.0], [CCCallFunc actionWithTarget:self selector:@selector(currentlyBigSmileGertyToNo)], nil]];   
    } 
}

-(void) pensiveGertyFace
{
    if (!_currentlyPensiveGerty) {
        
        _currentlyPensiveGerty = NO;
        _currentlyPensiveGerty = YES;
        
        int pensiveGertyFaceDelay = arc4random()%5;
        
        [pensiveGerty stopAllActions];
        
        [sadGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:pensiveGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:pensiveGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [cryingGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:pensiveGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [bigSmileGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:pensiveGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [happyGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:pensiveGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [pensiveGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:pensiveGertyFaceDelay*0.1], [CCFadeIn actionWithDuration:0.0], nil]];
        
        [pensiveGerty runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCFlipX actionWithFlipX: YES],[CCCallFunc actionWithTarget:self selector:@selector(pensiveGertyPlaySound)], [CCDelayTime actionWithDuration: 0.65], [CCFlipX actionWithFlipX: NO],[CCCallFunc actionWithTarget:self selector:@selector(pensiveGertyPlaySound)], [CCDelayTime actionWithDuration: 0.65], nil]]];
    } 
}

-(void) cryingGertyFace
{
    if (!_currentlyCryingGerty) {
        
        _currentlyPensiveGerty = NO;
        _currentlyCryingGerty = YES;
        
        int cryingGertyFaceDelay = arc4random()%5;
        
        [pensiveGerty stopAllActions];
        
        [sadGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1], [CCFadeOut actionWithDuration:0.0], nil]];
        
        [bigSmileGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [pensiveGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [happyGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1],[CCFadeOut actionWithDuration:0.0], nil]];
        
        [cryingGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1], [CCFadeIn actionWithDuration:0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeOut actionWithDuration: 0.0], nil]];
        
        [uncertainGerty runAction: [CCSequence actions: [CCDelayTime actionWithDuration:cryingGertyFaceDelay*0.1], [CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.0], [CCCallFunc actionWithTarget:self selector:@selector(currentlyCryingGertyToNo)], nil]];   
    } 
}

-(void) blowup
{        
    gertyPlayer2Alive = NO;
    [crackedScreen runAction: [CCFadeIn actionWithDuration: 0.0]];
    
    //[(Game*)_game player1IsTheWinnerScript];
    
    audioGerty2BeingDestroyed = [[self children] objectAtIndex:12];
    [audioGerty2BeingDestroyed play]; 
    //[self removeFromParentAndCleanup:YES];
}

@end
