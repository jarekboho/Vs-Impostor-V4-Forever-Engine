package;

import flixel.tweens.misc.NumTween;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.input.mouse.FlxMouseEventManager;
import meta.CoolUtil;

using StringTools;

class BeansPopup extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
    var bean:FlxSprite;
    var popupBG:FlxSprite;
    var theText:FlxText;
    var lerpScore:Int = 0;
    var canLerp:Bool = false;
	public function new(amount:Int, ?camera:FlxCamera = null)
	{
		super(x, y);
        this.y -= 100;
        lerpScore = amount;

        var colorShader:ColorShader = new ColorShader(0);

		popupBG = new FlxSprite(FlxG.width - 300, 0).makeGraphic(300, 100, 0xF8FF0000);
        popupBG.visible = false;
		popupBG.scrollFactor.set();
        add(popupBG);

        bean = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/base/bean'));
        bean.setPosition(popupBG.getGraphicMidpoint().x - 90, popupBG.getGraphicMidpoint().y - (bean.height / 2));
        bean.antialiasing = true;
        bean.updateHitbox(); 
        bean.scrollFactor.set();
		add(bean);	

        theText = new FlxText(popupBG.x + 90, popupBG.y + 35, 200, Std.string(amount), 35);
		theText.setFormat(Paths.font("ariblk.ttf"), 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        theText.setPosition(popupBG.getGraphicMidpoint().x - 10, popupBG.getGraphicMidpoint().y - (theText.height / 2));
        theText.updateHitbox();
		theText.borderSize = 3;
        theText.scrollFactor.set();
        theText.antialiasing = true;
        add(theText);

        bean.shader = colorShader.shader;
        theText.shader = colorShader.shader;

        FlxTween.tween(this, {y: 0}, 0.35, {ease: FlxEase.circOut});

        new FlxTimer().start(0.9, function(tmr:FlxTimer)
		{
            canLerp = true;
            colorShader.amount = 1;
            FlxTween.tween(colorShader, {amount: 0}, 0.8, {ease: FlxEase.expoOut});
            FlxG.sound.play(Paths.sound('getbeans'), 0.9);
        });

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		bean.cameras = cam;
		theText.cameras = cam;
		popupBG.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

    override function update(elapsed:Float){
        super.update(elapsed);
        if(canLerp){
            lerpScore = Math.floor(FlxMath.lerp(lerpScore, 0, CoolUtil.boundTo(elapsed * 4, 0, 1)/1.5));
            if(Math.abs(0 - lerpScore) < 10) lerpScore = 0;
        }

        theText.text = Std.string(lerpScore);
        bean.setPosition(popupBG.getGraphicMidpoint().x - 90, popupBG.getGraphicMidpoint().y - (bean.height / 2));
        theText.setPosition(popupBG.getGraphicMidpoint().x - 10, popupBG.getGraphicMidpoint().y - (theText.height / 2));
    }

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}