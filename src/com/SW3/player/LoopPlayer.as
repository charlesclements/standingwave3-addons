﻿package com.SW3.player
{
	
	import com.greensock.TweenMax;
	import com.noteflight.standingwave3.elements.AudioDescriptor;
	import com.noteflight.standingwave3.elements.IAudioSource;
	import com.noteflight.standingwave3.elements.IDirectAccessSource;
	import com.noteflight.standingwave3.elements.Sample;
	import com.noteflight.standingwave3.output.AudioPlayer;
	import com.noteflight.standingwave3.performance.AudioPerformer;
	import com.noteflight.standingwave3.performance.ListPerformance;
	import com.noteflight.standingwave3.performance.PerformableAudioSource;
	import com.noteflight.standingwave3.sources.SoundSource;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.SW3.gadget.LoopGadget;
	
	
	public class LoopPlayer extends Sprite
	{
		
		
		public var SOUNDS_DICTIONARY:Dictionary = new Dictionary;
		public var SOUNDS_ARRAY:Array = [];
		public var isPlaying:Boolean = false;
		private var looping:LoopGadget;
		
		private var player:AudioPlayer;
		
		// Constructor.
		
		/*
		public function LoopPlayer(target:IEventDispatcher=null)
		{
			super(target);
		}
		*/
		
		
		public function LoopPlayer(w:uint=300, h:uint=100)
		{
			trace( this );
			super();
			
			var bg:Bitmap = new Bitmap( new BitmapData( w, h, false, 0xcccccc ) );
			addChild( bg );
			
			looping = new LoopGadget;
			
			
		}
		
		
		public function play( id:String ):void
		{
			
			trace("LoopPlayer - play : " + id);
			looping.playLoop( id );	
			
		}
		
		
		// Add the Sound Sample to an internal Dictionary.
		public function addLoopSound(id:String, sound:Sound, loopStart:Number=0, loopEnd:Number=-1):void
		{
			
			trace("LoopPlayer - addLoopSound : " + id);
			looping.addLoopSound( id, sound, loopStart, loopEnd );
			
		}
		
		
		// Plays a particular sound.
		public function playLoop($id:String):void
		{
			
			trace("LoopPlayer - playLoop : " + $id);
			
			
			
			
			
			
			var o:Object = SOUNDS_DICTIONARY[ $id ];
			if( !o.isPlaying )
			{
				
				o.player = new AudioPlayer;
				o.player.play( o.source );
				o.isPlaying = true;
				
			}
			
		}
		
		
		// Plays an Array of loops by ID's passed in..
		public function playLoops($loopIDs:Array, $stopAllOthers:Boolean=false):void
		{
			
			trace("LoopPlayer - playLoops : " + $loopIDs);
			
			// Stop all others if true.
			if( $stopAllOthers ) stopAllLoops();
			
			for( var i:uint = 0; i < $loopIDs.length; i++ ) 
			{
				
				// Check to see if Object exists, and decide accordingly.
				if( SOUNDS_DICTIONARY[ $loopIDs[ i ] ] ) var o:Object = SOUNDS_DICTIONARY[ $loopIDs[ i ] ];
				else
				{
					
					trace( $loopIDs[ i ] + " - does not exist or has not been added.");
					continue;
					
				}
				
				// Checks to see if the audio is playing.
				if( !o.isPlaying )
				{
					
					o.source.resetPosition();
					o.player = new AudioPlayer;
					o.player.play( o.source );
					o.isPlaying = true;
					
				}
				
			}
			
		}
		
		
		// Stops a particular loop.
		public function stopLoop($id:String):void
		{
			
			trace("LoopPlayer - stopLoop : " + $id);
			
			// Check to see if Object exists, and decide accordingly.
			if( SOUNDS_DICTIONARY[ $id ] ) var o:Object = SOUNDS_DICTIONARY[ $id ];
			else
			{
				
				trace( $id + " - does not exist or has not been added.");
				return;
				
			}
			
			o.player.stop();
			o.isPlaying = false;
			
		}
		
		
		// Stops all existing loops.
		public function stopAllLoops():void
		{
			
			trace("LoopPlayer - stopAllLoops");
			for( var i:uint = 0; i < SOUNDS_ARRAY.length; i++ ) 
			{
				
				//trace(i);
				var o:Object = SOUNDS_DICTIONARY[ SOUNDS_ARRAY[ i ] ];
				o.player.stop( o.source );
				o.isPlaying = false;
				
			}
			//trace("LoopPlayer - stopAllLoops - END");
			
		}
		
		
		// Stops all existing loops.
		public function fadeLoop($id:String, $toFade:Number=0.5, $fromFade:Number=-1):void
		{
			
			trace("LoopPlayer - fadeLoop - " + $id);
			// Check to see if Object exists, and decide accordingly.
			if( SOUNDS_DICTIONARY[ $id ] ) var o:Object = SOUNDS_DICTIONARY[ $id ];
			else
			{
				
				trace( $id + " - does not exist or has not been added.");
				return;
				
			}
			//var o:Object = SOUNDS_DICTIONARY[ $id ];
			//o.isPlaying = false;
				
			// Do fading.
			if( o.isPlaying ) TweenMax.to( o.sample, 1, { onUpdate:o.sample.changeGain, onUpdateParams:[ $toFade, -1 * $fromFade ] } );
			else
			{
				
				o.player = new AudioPlayer;
				o.player.play( o.source );
				o.isPlaying = true;
				
			}
			
		}
		
			
		// Stops all existing loops.
		public function fadeOthers($idToKeep:String, $gainLevelToFadeOthersTo:Number=0.5):void
		{
			
			trace("LoopPlayer - fadeOthers");
			
			for( var i:uint = 0; i < SOUNDS_ARRAY.length; i++ ) 
			{
				
				trace(i);
				
				var o:Object = SOUNDS_DICTIONARY[ SOUNDS_ARRAY[ i ] ];
				o.isPlaying = false;
				
				// Do fading.
				if( o.isPlaying && o.id != $idToKeep ) TweenMax.to( o.sample, 1, { onUpdate:o.sample.changeGain, onUpdateParams:[ $gainLevelToFadeOthersTo, -1 * $gainLevelToFadeOthersTo ] } );
				else if( o.id == $idToKeep ) TweenMax.to( o.sample, 1, { onUpdate:o.sample.changeGain, onUpdateParams:[ 0.99, -0.99 ] } );
			}
			//trace("LoopPlayer - stopAllLoops - END");
			
		}
		
		
		// 
		public function removeLoopSound($id:String):void
		{
			
			trace("LoopPlayer - removeLoopSound - Not implemented yet : " + $id);
			
		}
		
		
		// 
		public function removeAllLoopSounds():void
		{
			
			trace("LoopPlayer - removeAllLoopSounds - Not implemented yet.");
			
		}
		
	}
	
	
}

