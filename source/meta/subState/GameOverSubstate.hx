package meta.subState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.Boyfriend;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.state.*;
import meta.state.menus.*;

class GameOverSubstate extends MusicBeatSubState
{
	//
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daBoyfriendType = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (PlayState.curStage)
		{
			case 'school':
				daBf = 'bf-pixel-dead';
			case 'polus':
				daBf = 'bf-genericdeath';
				if (PlayState.SONG.song.toLowerCase() == 'meltdown')
				daBf = 'bfg-dead';
			case 'ejected':
				daBf = 'bf-fall';
			case 'airship':
				daBf = 'bf-running-death';
				case 'defeat':
				if(FlxG.random.bool(10)){
				daBf = 'bf-defeat-dead-balls';
		FlxG.sound.play(Paths.sound('defeat_kill_ballz_sfx'));
				}
				else
				{
				daBf = 'bf-defeat-dead';
		FlxG.sound.play(Paths.sound('defeat_kill_sfx'));
				}
			case 'pretender':
				daBf = 'bf-pretender';
			case 'turbulence':
				daBf = 'bf_turb';
			case 'powstage':
				daBf = 'bf-picolobby';
			case 'charles':
				daBf = 'bf-henryphone';
			case 'kills':
				daBf = 'bf-deathkills';
			case 'who':
				daBf = 'bf-whitewhodie';
			case 'idk':
				daBf = 'bf-idk-dead';
			default:
				daBf = 'bf-genericdeath';
				//daBf = 'bf-dead';
		}

		switch (daBoyfriendType)
		{
			case 'bf-og':
				daBf = daBoyfriendType;
			case 'blackp':
				daBf = 'bf-blackp';
			case 'amongbf':
				daBf = 'bf-amongbf';
			case 'alien':
				daBf = 'bf-alien';
		}

		super();

		Conductor.songPosition = 0;

		if(daBf == 'bf-henryphone')
		{
			FlxG.camera.zoom = 0.9;
		}

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);
		add(bf);

		PlayState.boyfriend.destroy();

		if(daBf == 'bf-henryphone')
		{
			FlxG.camera.zoom = 0.9;
			camFollow = new FlxObject(bf.getGraphicMidpoint().x - 30, bf.getGraphicMidpoint().y - 60);
		}
		else
		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 40, 1, 1);
		add(camFollow);

		switch (PlayState.curStage)
		{
				case 'ejected':
		FlxG.sound.play(Paths.sound('ejected_death'));
				case 'defeat':

				case 'powstage':
		FlxG.sound.play(Paths.sound('picoDeath'));
				case 'charles':
		FlxG.sound.play(Paths.sound('henryDeath'));
				case 'school':
		FlxG.sound.play(Paths.sound('fnf_loss_sfx-pixel'));
				default:
		FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
		}
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
			{
				Main.switchState(this, new StoryMenuState());
			}
			else
				Main.switchState(this, new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
			//FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		switch (PlayState.curStage)
		{
				case 'ejected':
			FlxG.sound.playMusic(Paths.music('new_Gameover'));
				case 'o2':
			FlxG.sound.playMusic(Paths.music('Jorsawsee_Loop'));
				case 'voting-time':
			FlxG.sound.playMusic(Paths.music('Jorsawsee_Loop'));
				case 'turbulence':
			FlxG.sound.playMusic(Paths.music('Jorsawsee_Loop'));
				case 'victory':
			FlxG.sound.playMusic(Paths.music('Jorsawsee_Loop'));
				case 'powstage':
			FlxG.sound.playMusic(Paths.music('deathPicoMusicLoop'));
				case 'charles':
			FlxG.sound.playMusic(Paths.music('deathHenryMusicLoop'));
				case 'school':
			FlxG.sound.playMusic(Paths.music('gameOver-pixel'));
				default:
			FlxG.sound.playMusic(Paths.music('gameover_v4_LOOP'));
		}

		// if (FlxG.sound.music.playing)
		//	Conductor.songPosition = FlxG.sound.music.time;
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			//FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
		switch (PlayState.curStage)
		{
				case 'ejected':
			FlxG.sound.play(Paths.music('gameover-New_end'));
				case 'o2':
			FlxG.sound.play(Paths.music('Jorsawsee_End'));
				case 'voting-time':
			FlxG.sound.play(Paths.music('Jorsawsee_End'));
				case 'turbulence':
			FlxG.sound.play(Paths.music('Jorsawsee_End'));
				case 'victory':
			FlxG.sound.play(Paths.music('Jorsawsee_End'));
				case 'powstage':
			FlxG.sound.play(Paths.music('deathPicoMusicEnd'));
				case 'charles':
			FlxG.sound.play(Paths.music('deathHenryMusicEnd'));
				case 'school':
			FlxG.sound.play(Paths.music('gameOverEnd-pixel'));
				default:
			FlxG.sound.play(Paths.music('gameover_v4_End'));
		}
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					Main.switchState(this, new PlayState());
				});
			});
			//
		}
	}
}
