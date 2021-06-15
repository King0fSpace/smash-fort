//
//  CCAudioNode.h
//  PositionalAudio
//
//  Created by Fabio Rodella on 5/20/11.
//  Copyright 2011 Crocodella Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CDAudioManager.h"
#import "Game.h"

float projectileCollisionForceMultiplier;
int projectileChargingPitchPlayer1;
float pitch;


typedef enum {
	kAudioNodeSinglePlayProjectileCharging,
    kAudioNodeLoopProjectileCharging,
	kAudioNodePeriodicLoopProjectileCharging
} AudioNodePlayModeProjectileCharging;

@interface CDXAudioNodeProjectileCharging : CCNode {
    
    CDSoundEngine *soundEngine;
    CDSoundSource *sound;
    
    CCNode *earNode;
    
    int sourceId;
    
    AudioNodePlayModeProjectileCharging playMode;
    
    float minLoopFrequency;
    float maxLoopFrequency;
    
    float attenuation;
}

/**
 Node that acts as the listener
 */
@property (readwrite,retain) CCNode *earNode;

/**
 Playback loop mode
 */
@property (readwrite,assign) AudioNodePlayModeProjectileCharging playMode;

/**
 Minimum loop frequency for kAudioNodePeriodicLoop (in seconds)
 */
@property (readwrite,assign) float minLoopFrequency;

/**
 Maximum loop frequency for kAudioNodePeriodicLoop (in seconds)
 */
@property (readwrite,assign) float maxLoopFrequency;

/**
 Attenuation factor. The higher this value is, the steeper will be
 the volume drop as this sound moves farther from the listener. The
 default value is 0.003
 */
@property (readwrite,assign) float attenuation;

+ (CDXAudioNodeProjectileCharging *)audioNodeWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId;

+ (CDXAudioNodeProjectileCharging *)audioNodeWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId;

+ (CDXAudioNodeProjectileCharging *)audioNodeWithFile:(NSString *)file;


/**
 Initializes the audio node with an already created sound buffer, identified by
 the sourceId.
 */
- (id)initWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId;

/**
 Initializes the audio node with an audio file, creating a sound buffer with the
 specified sourceId.
 */
- (id)initWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId;

/**
 Initializes the audio node with an audio file using SimpleAudioEngine
 */
- (id)initWithFile:(NSString *)file;

- (void)play;

- (void)pause;

- (void)stop;

@end
