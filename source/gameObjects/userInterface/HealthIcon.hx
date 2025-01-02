package gameObjects.userInterface;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import sys.FileSystem;
import meta.state.PlayState;

using StringTools;

class HealthIcon extends FlxSprite
{
	// rewrite using da new icon system as ninjamuffin would say it
	public var sprTracker:FlxSprite;
	public var initialWidth:Float = 0;
	public var initialHeight:Float = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		updateIcon(char, isPlayer);
	}

	public function updateIcon(char:String = 'bf', isPlayer:Bool = false)
	{
		var trimmedCharacter:String = char;
		if (trimmedCharacter.contains('-'))
			trimmedCharacter = trimmedCharacter.substring(0, trimmedCharacter.indexOf('-'));

		var iconPath = char;
		while (!FileSystem.exists(Paths.getPath('images/icons/icon-' + iconPath + '.png', IMAGE))) {
			if (iconPath != trimmedCharacter)
				iconPath = trimmedCharacter;
			else
				iconPath = 'face';
			trace('$char icon trying $iconPath instead you fuck');
		}

		antialiasing = true;
		var iconGraphic:FlxGraphic = Paths.image('icons/icon-' + iconPath);
		loadGraphic(iconGraphic, true, Std.int(iconGraphic.width / 2), iconGraphic.height);

		initialWidth = width;
		initialHeight = height;

		animation.add('icon', [0, 1], 0, false, isPlayer);
		animation.play('icon');
		scrollFactor.set();
	}

	public function changeDadIcon(char:String)
	{
			if(PlayState.curStage.toLowerCase() == 'finalem'){
				frames = Paths.getSparrowAtlas('icons/icon-blackFinale');
				animation.addByPrefix('calm', 'black icon calm', 24, true);
				animation.addByPrefix('mad', 'black icon mad', 24, true);
				animation.play('calm');
			}
			else{
		loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);
		animation.add(char, [0, 1], 0, false, false);
		animation.play(char);
			}
	}

	public function changeBfIcon(char:String)
	{
		loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);
		animation.add(char, [0, 1], 0, false, true);
		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
