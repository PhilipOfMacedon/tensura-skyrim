Scriptname DemonLordsHakiScript extends ActiveMagicEffect  
{Script to control Demon Lord's Haki state}

Import GlobalVariable
Import Debug
Import Game
Import Utility

;======================================================================================;
;               PROPERTIES  /
;=============/

Float Property AuraExplosionDelay Auto
float property fDelay = 2.85 auto
{time to wait before switching to constant Imod}
ImageSpaceModifier property IntroFX auto
{IsMod applied at the start of the spell effect}
ImageSpaceModifier property MainFX auto
{main isMod for spell}
ImageSpaceModifier property OutroFX auto
{IsMod applied at the end of the spell effect}
Float Property fImodStrength = 1.0 auto
{IsMod Strength from 0.0 to 1.0}
Sound property IntroSoundFX auto ; create a sound property we'll point to in the editor
Sound Property MainSoundFX Auto ; create a sound property we'll point to in the editor
Sound property OutroSoundFX auto ; create a sound property we'll point to in the editor
Explosion Property ActivationExplosion Auto
Explosion Property MainExplosion Auto
Explosion Property DeactivationExplosion Auto
GlobalVariable Property DemonLordsHakiToggleGlobal auto
Spell Property BigStagger Auto

Int LoopInstance
Actor CasterActor

;======================================================================================;
;               EVENTS                     /
;=============/

Event OnEffectStart(Actor Target, Actor Caster)
	CasterActor = Caster
	if DemonLordsHakiToggleGlobal.GetValue() == 0.0
		BigStagger.Cast(CasterActor as ObjectReference)
		DemonLordsHakiToggleGlobal.setValue(1.0)
		int instanceID = IntroSoundFX.play(target as objectReference)          ; play IntroSoundFX sound from my self
		introFX.apply(fImodStrength)                                  ; apply isMod at full strength
		Target.PlaceAtMe(ActivationExplosion)
		utility.wait(fDelay)                            ; NOTE - neccessary? 
		if DemonLordsHakiToggleGlobal.GetValue() == 1.0
			introFX.PopTo(MainFX,fImodStrength)	
			DemonLordsHakiToggleGlobal.setValue(2.0)
		endif
		LoopInstance = MainSoundFX.Play(Target as ObjectReference)
		Debug.Notification("ATTENTION: Lesser beings are being coerced by your aura!")
		RegisterForSingleUpdate(AuraExplosionDelay)
	elseif DemonLordsHakiToggleGlobal.GetValue() == 1.0
		introFX.PopTo(MainFX,fImodStrength)	
		DemonLordsHakiToggleGlobal.setValue(2.0)
		self.dispel()
	else
		self.dispel()
	endif
	
EndEvent

Event OnUpdate()
	If (DemonLordsHakiToggleGlobal.GetValue() == 2.0)
		CasterActor.PlaceAtMe(MainExplosion)
		BigStagger.Cast(CasterActor as ObjectReference)
		RegisterForSingleUpdate(AuraExplosionDelay)
	EndIf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
	if DemonLordsHakiToggleGlobal.GetValue() == 2.0
		DemonLordsHakiToggleGlobal.setValue(3.0)
		Target.PlaceAtMe(DeactivationExplosion)
		Sound.StopInstance(LoopInstance)
		Debug.Notification("You're now suppressing your aura.")
		int instanceID = OutroSoundFX.play(target as objectReference)         ; play OutroSoundFX sound from my self
		MainFX.PopTo(OutroFX,fImodStrength)
		introFX.remove()
		DemonLordsHakiToggleGlobal.setValue(0.0)
	endif

endEvent