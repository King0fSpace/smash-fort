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

float projectileCollisionForceMultiplier;
double chargedShotTimeTotal;



typedef enum {
	kAudioNodeBlocksSinglePlay,
    kAudioNodeBlocksLoop,
	kAudioNodeBlocksPeriodicLoop
} AudioNodeBlocksPlayMode;

@interface CDXAudioNodeBlocks : CCNode {
    
    CDSoundEngine *soundEngine;
    CDSoundSource *sound;
    
    CCNode *earNode;
    
    int sourceId;
    
    AudioNodeBlocksPlayMode playMode;
    
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
@property (readwrite,assign) AudioNodeBlocksPlayMode playMode;

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

+ (CDXAudioNodeBlocks *)audioNodeWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId;

+ (CDXAudioNodeBlocks *)audioNodeWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId;

+ (CDXAudioNodeBlocks *)audioNodeWithFile:(NSString *)file;

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

- (void)increasePitch;

- (void)play;

- (void)pause;

- (void)stop;

@end
