//
//  CCAudioNode.m
//  PositionalAudio
//
//  Created by Fabio Rodella on 5/20/11.
//  Copyright 2011 Crocodella Software. All rights reserved.
//

#import "CDXAudioNodeProjectileCharging.h"
#import "SimpleAudioEngine.h"

@implementation CDXAudioNodeProjectileCharging

@synthesize earNode;
@synthesize playMode;
@synthesize minLoopFrequency;
@synthesize maxLoopFrequency;
@synthesize attenuation;

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) rand() / RAND_MAX) * diff) + smallNumber;
}

+ (CDXAudioNodeProjectileCharging *)audioNodeWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    return [[[self alloc] initWithSoundEngine:se sourceId:sId] autorelease];
}

+ (CDXAudioNodeProjectileCharging *)audioNodeWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    return [[[self alloc] initWithFile:file soundEngine:se sourceId:sId] autorelease];
}

+ (CDXAudioNodeProjectileCharging *)audioNodeWithFile:(NSString *)file {
    return [[[self alloc] initWithFile:file] autorelease];
}

- (id)initWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    
    if ((self = [super init])) {
        
        attenuation = 0.003f;
        
        playMode = kAudioNodeSinglePlayProjectileCharging;
        
        soundEngine = [se retain];
        
        sourceId = sId;
        
        sound = [[soundEngine soundSourceForSound:sourceId sourceGroupId:0] retain];
    }
    return self;
}

- (id)initWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    
    if ((self = [super init])) {
        
        attenuation = 0.0002f;
        
        playMode = kAudioNodeSinglePlayProjectileCharging;
        
        soundEngine = [se retain];
        
        sourceId = sId;
        
        [soundEngine loadBuffer:sourceId filePath:file];
        sound = [[soundEngine soundSourceForSound:sourceId sourceGroupId:0] retain];
    }
    return self;
}

- (id)initWithFile:(NSString *)file {
    
    if ((self = [super init])) {
        
        attenuation = 0.0002f;
        
        playMode = kAudioNodeSinglePlayProjectileCharging;
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:file];
        sound = [[[SimpleAudioEngine sharedEngine] soundSourceForFile:file] retain];
    }
    
    return self;
}

- (void)dealloc {
    [self stop];
    [sound release];
    [soundEngine release];
    [super dealloc];
}

- (void)play {
    
    [self unschedule:@selector(play)];
    
    switch (playMode) {
        case kAudioNodeSinglePlayProjectileCharging:
            sound.looping = NO;
            break;
        case kAudioNodeLoopProjectileCharging:
            sound.looping = YES;
            break;
        case kAudioNodePeriodicLoopProjectileCharging:
            sound.looping = NO;
            float delay = sound.durationInSeconds + [self randomFloatBetween:minLoopFrequency and:maxLoopFrequency];
            [self schedule:@selector(play) interval:delay];
        default:
            break;
    }
    
    sound.gain = 0.0f;
    
    [sound play];
}

- (void)pause {
    [sound pause];
}

- (void)stop {
    [sound stop];
    [self unschedule:@selector(play)];
}

- (void)visit {
    CGPoint realPos = [self convertToWorldSpace:CGPointZero];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
	
    CGPoint earPos = ccp(size.width / 2, size.height / 2);
    if (earNode) {
        earPos = [earNode convertToWorldSpace:CGPointZero];
    }
    
    float dist = sqrt((realPos.x - earPos.x) * (realPos.x - earPos.x) + (realPos.y - earPos.y) * (realPos.y - earPos.y));
    
    float distX = realPos.x - earPos.x;
    
    pitch = 0.5 + projectileChargingPitchPlayer1*0.15;
    
    //NSLog (@"pitch = %f", pitch);
    
    if (skillLevelBonus == 0) {
        
        if (projectileChargingPitchPlayer1 >= 9.0) {
        
            pitch = 0.5 + 9.0*0.15;
        }
    }
    
    else if (skillLevelBonus == 1) {
        
        if (projectileChargingPitchPlayer1 >= 12.0) {
        
            pitch = 0.5 + 12.0*0.15;
        }
    }
    
    else if (skillLevelBonus == 2) {
        
        if (projectileChargingPitchPlayer1 >= 15.0) {
            
            pitch = 0.5 + 15.0*0.15;
        }
    }
    
    
 /*   if (projectileChargingPitchPlayer1 > 10.0) {
        
        pitch = 10;
    }
 */   
    sound.pitch = pitch;
    sound.pan = distX / (size.width / 2);
    
    float gain = (1.0f - (0.5*dist * attenuation));
    
    if (gain < 0.0f) gain = 0.0f;
    if (gain > 1.0f) gain = 1.0f;
    
    sound.gain = gain - 0.3;
    
    //projectileChargingPitchPlayer1 = 0;
    
    [super visit];
}

- (void)onExit {
    [self stop];
}

@end
