﻿package com.SW3.util{			import com.noteflight.standingwave3.elements.AudioDescriptor;	import com.noteflight.standingwave3.elements.IAudioSource;	import com.noteflight.standingwave3.elements.Sample;	import com.noteflight.standingwave3.performance.AudioPerformer;	import com.noteflight.standingwave3.performance.ListPerformance;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.media.Sound;	import com.noteflight.standingwave3.elements.IDirectAccessSource;	import com.noteflight.standingwave3.output.AudioPlayer;	import flash.sampler.NewObjectSample;	import flash.utils.Dictionary;	import com.noteflight.standingwave3.generators.SoundGenerator;	import com.noteflight.standingwave3.sources.SoundSource;	import com.greensock.TweenMax;	import com.noteflight.standingwave3.performance.PerformableAudioSource;			public class Util extends EventDispatcher	{								//public static var SOUNDS_DICTIONARY:Dictionary = new Dictionary;				//public static var SOUNDS_ARRAY:Array = [];								public function Util(target:IEventDispatcher=null)		{			super(target);		}						// Creates a looped sample from a sound.		public static function combineSamples($samples:Array):IAudioSource		{						trace("combineSamples");			var sequence:ListPerformance = new ListPerformance();			for( var i:uint = 0; i < $samples.length; i++ ){ sequence.addSourceAt(0, $samples[ i ] as IAudioSource) };			return new AudioPerformer(sequence, new AudioDescriptor() );					}						// Creates a looped sample from a sound.		public static function createLoopedSample($sound:Sound, $loop:uint=10, $endTrimBytes:uint=21000):IAudioSource		{						trace("createLoopedSample");						// Length of track.			var length:Number = ( $sound.length * 44.1 ) - $endTrimBytes;						// Create sample			var tempSample:Sample = new Sample( new AudioDescriptor, length );						// Extract sound into sample.			tempSample.extractSound( $sound, 0, length );						// Create Sample with enlongated length.			var returnSample:Sample = new Sample( new AudioDescriptor, length * $loop );						// Need to add byteArray data to the end, using multiplier variable.			for( var i:uint = 0; i < $loop; i++ )			{								returnSample.mixIn( tempSample, 1.0, length * i );				returnSample.position = ( length * i );							}						tempSample.clear();			returnSample.resetPosition();						return returnSample;					}					// 		public static function setSampleObject($sound:Sound, $beginsInSeconds:uint=0, $endsInSeconds:uint=1000):Object		{						var o:Object = SOUNDS_DICTIONARY[ $sound ] = { sound:$sound, sampleBegins:$beginsInSeconds, sampleEnds:$endsInSeconds };			SOUNDS_ARRAY.push( o );			o.index = SOUNDS_ARRAY.length;			return o;					}						// 		public static function getSampleObject($sound:Sound):Object		{									//SOUNDS.h						var o:Object = {};									return o;											}										private static function checkLooping($key:*):void		{									trace("checkLooping");						//TweenMax.to 						var o:Object = SOUNDS_DICTIONARY[ $key ];									if( o.isPlaying != true )			{												//( o.player as AudioPlayer ).play( o.sample );				( o.player as AudioPlayer ).play( o.soundGenerator );				o.isPlaying = true;				//TweenMax.to( o, o.sampleEndsInSeconds, { onComplete:checkLooping, onCompleteParams:[ $key ] } );				return;							}			else			{																			}						trace("+");			//( o.player as AudioPlayer ).source.resetPosition();			( o.player as AudioPlayer ).stop( o.sample );			( o.player as AudioPlayer ).play( o.sample );									//						//( o.player as AudioPlayer ).position = 0;															/*			if( ( o.player as AudioPlayer ).position )			{								trace("resetPosition");				( o.player as AudioPlayer ).source.resetPosition();							}			else			{								trace("play");				( o.player as AudioPlayer ).play( o.sample );				( o.player as AudioPlayer ).source.resetPosition();							}						*/																					/*			( o.player as AudioPlayer ).position;			( o.player as AudioPlayer ).source.frameCount;															//( o.player as AudioPlayer ).source.resetPosition();																		trace( ( o.player as AudioPlayer ).position );			trace( ( ( o.player as AudioPlayer ).source as Sample ).duration );			trace( ( o.player as AudioPlayer ).source.frameCount );			*/			trace("");						//trace(o.sample.duration);																		//( o.player as AudioPlayer ).position = o.sampleStartsInSeconds;									//( o.player as AudioPlayer ).												/**/			// Keep player going.			//o.player.play( o.performableAudioSource );			//( o.player as AudioPlayer ).play( o.sample )												/*			trace( ( o.player as AudioPlayer ).source.position );									//if( ( o.player as AudioPlayer ).source.position			( o.player as AudioPlayer ).source.resetPosition();						*/						//TweenMax.to( o, o.sampleEndsInSeconds, { onComplete:checkLooping, onCompleteParams:[ $key ] } );																										}														// 		public static function sequence($sound:Sound, $sampleBeginsInSeconds:Number=-1, $sampleEndsInSeconds:Number=-1, $sampleStartsInSeconds:Number=-1):void		{									trace("sequence");									var length:Number = $sound.length * 44.1;			trace(length);			//trace(length/2);									trace( ( 44100 * 16 * 2 ) / $sampleEndsInSeconds );									//$sound.																					var ss:SoundSource = new SoundSource( $sound, new AudioDescriptor );						trace( "duration : " + ss.duration );												var end:uint = ( $sampleEndsInSeconds * length ) / ss.duration;			trace( "end : " + end );						//var sample:Sample = ss.getSampleRange( 0, ( 44100 * 16 * 2 ) / $sampleEndsInSeconds  );						var sample:Sample = ss.getSampleRange( 0, end  );									ss.sound = null;																											trace(sample.frameCount);						var sequence:ListPerformance = new ListPerformance();						for( var i:uint = 0; i < 100; i++ )			{								sequence.addSourceAt( i * $sampleEndsInSeconds, sample.clone() );															}						/*			sequence.addSourceAt(0 * $sampleEndsInSeconds, sample.clone() );			sequence.addSourceAt(1 * $sampleEndsInSeconds, sample.clone() );			sequence.addSourceAt(2 * $sampleEndsInSeconds, sample.clone() );			sequence.addSourceAt(3 * $sampleEndsInSeconds, sample.clone() );			*/						//sequence.									// Play it back.			var source:IAudioSource = new AudioPerformer(sequence, new AudioDescriptor );									//source.						var player:AudioPlayer = new AudioPlayer;//( 8000 );			player.play(source);															TweenMax.to( {}, 20, { onComplete:player.stop, onCompleteParams:[ source ]  } );			TweenMax.to( {}, 5.1, { onComplete:source.resetPosition  } );			/**/					}										// 		public static function loopSound($sound:Sound, $sampleBeginsInSeconds:Number=-1, $sampleEndsInSeconds:Number=-1, $sampleStartsInSeconds:Number=-1):void		{						trace("loopSound");						var o:Object;			var key:* = $sound;// Currently making the $sound variable the key for the Dictionary.						try			{								if( SOUNDS_DICTIONARY[ key ] == null ) o = setSampleObject( $sound, $sampleBeginsInSeconds, $sampleEndsInSeconds );							}			catch(e:Error)			{								o = SOUNDS_DICTIONARY[ key ];  							}												var length:Number = $sound.length * 44.1;									var ss:SoundSource = new SoundSource( $sound, new AudioDescriptor );									ss.duration									//var sample:Sample = ss.getSampleRange( 0, length );						// Set new obj vars.			o.key = key;			o.sound = $sound;			o.sample = ss.getSampleRange( 0, length );			o.player = new AudioPlayer;			o.sampleBeginsInSeconds = $sampleBeginsInSeconds;			o.sampleEndsInSeconds = $sampleEndsInSeconds;			o.sampleStartsInSeconds = $sampleStartsInSeconds;									o.performableAudioSource = new PerformableAudioSource( o.sampleBeginsInSeconds, o.sample as IAudioSource );			o.soundGenerator = new SoundGenerator( o.sound, new AudioDescriptor );									trace(o.performableAudioSource);												//( o.sample as Sample ).duration									// Get player going.			//o.player.play( o.performableAudioSource as IAudioSource );									//o.player.play( o.sample as IAudioSource );															checkLooping( o.key );								}						// Creates a looped sample from a sound.		public static function createSample($sound:Sound, $endTrimBytes:uint=21000):IDirectAccessSource		{						trace("createLoopedSample");						// Length of track.			var length:Number = ( $sound.length * 44.1 ) - $endTrimBytes;						// Create sample			var tempSample:Sample = new Sample( new AudioDescriptor, length );						// Extract sound into sample.			tempSample.extractSound( $sound, 0, length );																		/*			// Create Sample with enlongated length.			var returnSample:Sample = new Sample( new AudioDescriptor, length * $loop );						// Need to add byteArray data to the end, using multiplier variable.			for( var i:uint = 0; i < $loop; i++ )			{								returnSample.mixIn( tempSample, 1.0, length * i );				returnSample.position = ( length * i );							}						tempSample.clear();												returnSample.resetPosition();			*/												return tempSample;					}				}		}