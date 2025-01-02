package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import openfl.utils.Assets as OpenFlAssets;
import meta.MusicBeat.MusicBeatState;
import meta.state.PlayState;
import meta.CoolUtil;
import meta.data.*;
import meta.data.Song.SwagSong;

using StringTools;

#if sys
import sys.FileSystem;
#end

class HenryState extends MusicBeatState
{
    
    var freezeFrame:FlxSprite;
    var grad:FlxSprite;

    var mic:FlxSprite;
    var stare:FlxSprite;
    var sock:FlxSprite;

    var canClick:Bool = false;

	override function create()
	{
		super.create();

        freezeFrame = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/henry/finalframe'));
        freezeFrame.width = FlxG.width;
        freezeFrame.height = FlxG.height;
        freezeFrame.updateHitbox();
        freezeFrame.screenCenter();
		add(freezeFrame);

        grad = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/henry/hguiofuhjpsod'));
        grad.width = FlxG.width;
        grad.height = FlxG.height;
        grad.updateHitbox();
        grad.screenCenter();
		add(grad);

        sock = new FlxSprite(0, 0);
        sock.frames = Paths.getSparrowAtlas('backgrounds/henry/Sock_Puppet_Option');	
        sock.animation.addByPrefix('select', 'Sock Puppet Select', 24, false);
        sock.animation.addByPrefix('deselect', 'Sock Puppet', 24, false);
        sock.scale.set(0.5, 0.5);
       // option.animation.play('select');
        sock.visible = false;
        sock.updateHitbox();

        stare = new FlxSprite(0, 0);
        stare.frames = Paths.getSparrowAtlas('backgrounds/henry/Stare_Down_Option');	
        stare.animation.addByPrefix('select', 'Stare Down Select', 24, false);
        stare.animation.addByPrefix('deselect', 'Stare Down', 24, false);
        stare.scale.set(0.5, 0.5);
       // option.animation.play('select');
        stare.visible = false;
        stare.updateHitbox();

        mic = new FlxSprite(0, 0);
        mic.frames = Paths.getSparrowAtlas('backgrounds/henry/Microphone_Option');	
        mic.animation.addByPrefix('select', 'Microphone Select', 24, false);
        mic.animation.addByPrefix('deselect', 'Microphone', 24, false);
        mic.scale.set(0.5, 0.5);
        mic.visible = false;
        mic.updateHitbox();

        add(sock);
        add(stare);
        add(mic);

        mic.antialiasing = true;
        stare.antialiasing = true;
        sock.antialiasing = true;

        mic.screenCenter();
        mic.x -= FlxG.width * 0.15;
        mic.y -= FlxG.height * 0.15;

        sock.screenCenter();
        sock.x += FlxG.width * 0.15;
        sock.y -= FlxG.height * 0.15;

        stare.screenCenter();
        stare.y += FlxG.height * 0.15;

        //options();
	options();
    }

    function options():Void{

        new FlxTimer().start(1, function(tmr:FlxTimer) {
            mic.visible = true;
            FlxG.sound.play(Paths.sound('mic'), 0.6);
		});

        new FlxTimer().start(2, function(tmr:FlxTimer) {
            sock.visible = true;
            FlxG.sound.play(Paths.sound('sock'), 0.6);
		});

        new FlxTimer().start(3, function(tmr:FlxTimer) {
            stare.visible = true;
            FlxG.sound.play(Paths.sound('stare'), 0.6);
            canClick = true;
		});

    }

    function click(type:String){
        canClick = false;
        sock.visible = false;
        stare.visible = false;
        mic.visible = false;
        freezeFrame.visible = false;
        grad.visible = false;
        switch(type){
            case 'mic':
                win();
            case 'sock':
                dead();
            case 'stare':
                dead();
        }
    }

    function dead(){
        canClick = true;
        sock.visible = true;
        stare.visible = true;
        mic.visible = true;
        freezeFrame.visible = true;
        grad.visible = true;
    }

    function win(){
        startWeek();
    }


    function startWeek():Void{
        
        var _difficulty:Int = 2; // TODO: make this the actual diff
        var _week:Int = 19;

        // We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.

		// Nevermind that's stupid lmao
			PlayState.storyPlaylist = Main.gameWeeks[_week][0].copy();
			PlayState.isStoryMode = true;

			var diffic:String = '-' + CoolUtil.difficultyFromNumber(_difficulty).toLowerCase();
			diffic = diffic.replace('-normal', '');

		PlayState.storyDifficulty = _difficulty;
		PlayState.freeplayDifficulty = _difficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.storyWeek = _week;
		PlayState.campaignScore = 0;

		Main.switchState(this, new PlayState());
    }

    var over:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
        if(canClick){
        if (FlxG.mouse.overlaps(sock))
		{
			if(!over){
                over = true;
                FlxG.sound.play(Paths.sound('sock'), 0.6);
                sock.animation.play('select', true);
            }
			if(FlxG.mouse.pressed)
			{
                click('sock');
			}
        }else{
            if(sock.animation.curAnim != null){
                sock.animation.play('deselect', true);
            }
        }

        if (FlxG.mouse.overlaps(mic))
		{
			if(!over){
                over = true;
                FlxG.sound.play(Paths.sound('mic'), 0.6);
                mic.animation.play('select', true);
            }
			if(FlxG.mouse.pressed)
			{
                click('mic');
			}
        }else{
            if(mic.animation.curAnim != null){
                mic.animation.play('deselect', true);
            }
        }

        if (FlxG.mouse.overlaps(stare))
		{
			if(!over){
                over = true;
                FlxG.sound.play(Paths.sound('stare'), 0.6);
                stare.animation.play('select', true);
            }
			if(FlxG.mouse.pressed)
			{
                click('stare');
			}
        }else{
            if(stare.animation.curAnim != null){
                stare.animation.play('deselect', true);
            }
        }

        if(!FlxG.mouse.overlaps(stare) && !FlxG.mouse.overlaps(mic) && !FlxG.mouse.overlaps(sock)){
            over = false;
        }
        }
	}
}