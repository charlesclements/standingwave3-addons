﻿package{		// Imports.	import com.greensock.events.LoaderEvent;	import com.greensock.loading.LoaderMax;	import com.greensock.loading.MP3Loader;	import flash.display.Sprite;	import flash.events.Event;	import com.greensock.TweenMax;	import com.SW3.gadget.LoopGadget;	import flash.media.Sound;		// Class.	public class LoopingWork0 extends Sprite	{			// Vars.		private var loader:LoaderMax;						// Constructor.		public function LoopingWork0()		{						trace("LoopingWork0");						loader = new LoaderMax( { name:"audio", onComplete:onSoundsLoaded } );			loader.append( new MP3Loader( "assets/Beat.mp3", { autoPlay:false } ) );			loader.append( new MP3Loader( "assets/Clap.mp3", { autoPlay:false } ) );			loader.append( new MP3Loader( "assets/Boom.mp3", { autoPlay:false } ) );			loader.load();					}						private function onSoundsLoaded(e:LoaderEvent):void		{						trace("onSoundsLoaded");			var looping:LoopGadget = new LoopGadget;			looping.addLoopSound( "Beat", e.currentTarget.content[ 0 ] as Sound, 0, 10 );			looping.addLoopSound( "Clap", e.currentTarget.content[ 1 ] as Sound, 0, 10 );			//looping.addLoopSound( "Boom", e.currentTarget.content[ 2 ] as Sound, 0, 10 ); // Commented out to test possible error.						looping.playLoop( "Beat" );// Play the "Beat" loop.			looping.playLoop( "Clap" );// Play the "Clap" loop.			looping.stopLoop( "Beat" );// Stop the "Beat" loop.			looping.playLoop( "Beat" );// Play the "Beat" loop.			looping.playLoop( "Beat" );// Play the "Beat" loop again to test if it would error out..						looping.stopAllLoops();// Stop all the loops.			looping.playLoops( [ "Beat", "Clap", "Boom" ] );// Play all the loops. Test to see if "Boom" will error out.					}					}		}