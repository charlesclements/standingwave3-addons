﻿package com.SW3.gadget{		import com.greensock.TweenMax;	import com.noteflight.standingwave3.elements.AudioDescriptor;	import com.noteflight.standingwave3.elements.IAudioSource;	import com.noteflight.standingwave3.elements.IDirectAccessSource;	import com.noteflight.standingwave3.elements.Sample;	import com.noteflight.standingwave3.output.AudioPlayer;	import com.noteflight.standingwave3.performance.AudioPerformer;	import com.noteflight.standingwave3.performance.ListPerformance;	import com.noteflight.standingwave3.performance.PerformableAudioSource;	import com.noteflight.standingwave3.sources.SoundSource;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.media.Sound;	import flash.utils.Dictionary;		
	// Class.	public class LoopGadget extends EventDispatcher	{				
		// Vars.		public var SOUNDS_DICTIONARY:Dictionary = new Dictionary;		public var SOUNDS_ARRAY:Array = [];						// Constructor.		public function LoopGadget(target:IEventDispatcher=null)		{			super(target);		}						// Creates a looped sample from a sound.		public function combineSamples($samples:Array):IAudioSource		{						trace("combineSamples");			var sequence:ListPerformance = new ListPerformance();			for( var i:uint = 0; i < $samples.length; i++ ){ sequence.addSourceAt(0, $samples[ i ] as IAudioSource) };			return new AudioPerformer( sequence, new AudioDescriptor() );					}						// Add the Sound Sample to an internal Dictionary.		public function addLoopSound($id:String, $sound:Sound, $beginsInSeconds:Number=-1, $endsInSeconds:Number=-1):void		{						// Placed condition in try/catch in case of error.			try			{								if( SOUNDS_DICTIONARY[ $id ] != null ) 				{										trace( "LoopGadget - addLoopSound : " + $id + " : Loop already exists." ); 					return;									}							}			catch(e:Error)			{								trace( "LoopGadget - addLoopSound : " + $id + " : Can be created." ); 							}						// Create loop stuff here.			var length:Number = $sound.length * 44.1;			var ss:SoundSource = new SoundSource( $sound, new AudioDescriptor );			var begin:uint = ( $beginsInSeconds * length ) / ss.duration;			var end:uint = ( $endsInSeconds > -1 ) ? ( $endsInSeconds * length ) / ss.duration : length;			var sample:Sample = ss.getSampleRange( begin, end );			sample.normalize();						// Create ListPerformance.			var sequence:ListPerformance = new ListPerformance();			for( var i:uint = 0; i < 100; i++ ){ sequence.addSourceAt( i * $endsInSeconds, sample.clone() ) };						// Set new obj vars.			var o:Object = {};			o.sample = sample;			o.source = new AudioPerformer(sequence, new AudioDescriptor );			o.player = new AudioPlayer;			o.isPlaying = false;						// Add to Dictionary and Array.			SOUNDS_DICTIONARY[ $id ] = o;			SOUNDS_ARRAY.push( $id );					}						public function contains($id:String):Boolean		{						var b:Boolean = ( SOUNDS_DICTIONARY[ $id ] != null ) ? true : false;			trace("LoopGadget - contains : " + $id + " = " + b );			return b;					}						// Plays a particular sound.		public function playLoop($id:String):void		{												// Check to see if Object exists, and decide accordingly.			if( SOUNDS_DICTIONARY[ $id ] ) 			{								trace("LoopGadget - playLoop : " + $id);				var o:Object = SOUNDS_DICTIONARY[ $id ];				if( !o.isPlaying )				{										o.player = new AudioPlayer;					o.player.play( o.source );					o.isPlaying = true;									}							}			else			{								trace( "LoopGadget - playLoop : Cannot play " + $id + " - because it does not exist or has not been added.");							}					}						// Plays an Array of loops by ID's passed in..		public function playLoops($loopIDs:Array, $stopAllOthers:Boolean=false):void		{						trace("LoopGadget - playLoops : " + $loopIDs);						// Stop all others if true.			if( $stopAllOthers ) stopAllLoops();						for( var i:uint = 0; i < $loopIDs.length; i++ ) 			{								// Check to see if Object exists, and decide accordingly.				if( SOUNDS_DICTIONARY[ $loopIDs[ i ] ] ) var o:Object = SOUNDS_DICTIONARY[ $loopIDs[ i ] ];				else				{										trace( "LoopGadget - playLoops : " + $loopIDs[ i ] + " - does not exist or has not been added.");					continue;									}								// Checks to see if the audio is playing.				if( !o.isPlaying )				{										o.source.resetPosition();					o.player = new AudioPlayer;					o.player.play( o.source );					o.isPlaying = true;									}							}					}						// Stops a particular loop.		public function stopLoop($id:String):void		{						// Check to see if Object exists, and decide accordingly.			if( SOUNDS_DICTIONARY[ $id ] ) var o:Object = SOUNDS_DICTIONARY[ $id ];			else			{								trace( "LoopGadget - stopLoop : Cannot stop " + $id + " - because it does not exist or has not been added.");				return;							}						trace("LoopGadget - stopLoop : " + $id);			o.player.stop();			o.isPlaying = false;					}						// Stops all existing loops.		public function stopAllLoops():void		{						trace("LoopGadget - stopAllLoops");			for( var i:uint = 0; i < SOUNDS_ARRAY.length; i++ ) 			{								//trace(i);				var o:Object = SOUNDS_DICTIONARY[ SOUNDS_ARRAY[ i ] ];				o.player.stop( o.source );				o.isPlaying = false;							}			//trace("LoopGadget - stopAllLoops - END");					}						// Stops all existing loops.		public function fadeOthers($idToKeep:String, $gainLevelToFadeOthersTo:Number=0.5):void		{						trace("LoopGadget - fadeOthers - Not implemented yet");						for( var i:uint = 0; i < SOUNDS_ARRAY.length; i++ ) 			{								trace(i);								var o:Object = SOUNDS_DICTIONARY[ SOUNDS_ARRAY[ i ] ];				o.isPlaying = false;								// Do fading.				if( o.isPlaying && o.id != $idToKeep ) TweenMax.to( o.sample, 1, { onUpdate:o.sample.changeGain, onUpdateParams:[ $gainLevelToFadeOthersTo, -1 * $gainLevelToFadeOthersTo ] } );				else if( o.id == $idToKeep ) TweenMax.to( o.sample, 1, { onUpdate:o.sample.changeGain, onUpdateParams:[ 0.99, -0.99 ] } );			}			//trace("LoopGadget - stopAllLoops - END");					}						// 		public function removeLoopSound($id:String):void		{						trace("LoopGadget - removeLoopSound - Not implemented yet : " + $id);					}						// 		public function removeAllLoopSounds():void		{						trace("LoopGadget - removeAllLoopSounds - Not implemented yet.");					}			}		}