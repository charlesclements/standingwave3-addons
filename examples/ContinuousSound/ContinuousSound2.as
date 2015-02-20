﻿package{		// Imports.	import com.greensock.events.LoaderEvent;	import com.greensock.loading.LoaderMax;	import com.greensock.loading.MP3Loader;	import flash.display.Sprite;	import flash.events.Event;	import com.greensock.TweenMax;	import com.SW3.gadget.LoopGadget;	import com.SW3.player.SilentContinuousPlayer;	import flash.media.Sound;		// Class.	public class ContinuousSound2 extends Sprite	{				// Vars.		private var loader:LoaderMax;		var player:SilentContinuousPlayer = new SilentContinuousPlayer;						// Constructor.		public function ContinuousSound2()		{						trace("LoopingWork2");						loader = new LoaderMax( { name:"audio", onComplete:onSoundsLoaded } );			loader.append( new MP3Loader( "assets/Beat.mp3", { autoPlay:false } ) );			loader.load();					}						private function onSoundsLoaded(e:LoaderEvent):void		{						trace("onSoundsLoaded");						// Start playing the silent player.			player.play();						// Calls to trace position properties.			delayedCall();						// Pause the player.			player.pause();						// Calls to trace position properties.			TweenMax.to( {}, 2.75, { onComplete:delayedCall } );			TweenMax.to( {}, 5.36, { onComplete:delayedCall } );						// Resume playing.			TweenMax.to( {}, 5.5, { onComplete:player.resume } );						// Calls to trace position properties.			TweenMax.to( {}, 7, { onComplete:delayedCall } );					}						// Trace properties.		private function delayedCall():void		{						trace( "" );			trace( "paused: " + player.paused );			trace( "Frames: " + player.position );			trace( "Seconds: " + player.positionInSeconds );			trace( "Milliseconds: " + player.positionInMilliseconds );					}					}		}