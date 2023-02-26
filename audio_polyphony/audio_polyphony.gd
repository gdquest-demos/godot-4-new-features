extends Control

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var play_button: Button = %PlayButton
@onready var polyphony_label: Label = %PolyphonyLabel
@onready var polyphony_slider: HSlider = %PolyphonySlider
@onready var playback_label: Label = %PlaybackLabel
@onready var playback_slider: HSlider = %PlaybackSlider
@onready var burst_label: Label = %BurstLabel
@onready var burst_slider: HSlider = %BurstSlider


func _ready():
	var fn_update_labels := func(_v):
		polyphony_label.text = str(polyphony_slider.value)
		playback_label.text = str(playback_slider.value)
		burst_label.text = str(burst_slider.value)
	
	polyphony_slider.value_changed.connect(fn_update_labels)
	playback_slider.value_changed.connect(fn_update_labels)
	burst_slider.value_changed.connect(fn_update_labels)
	
	fn_update_labels.call(0)
	
	play_button.pressed.connect(
		func():
			audio_stream_player.max_polyphony = int(polyphony_slider.value)
			for i in range(playback_slider.value):
				audio_stream_player.play()
				await get_tree().create_timer(burst_slider.value/playback_slider.value).timeout
	)
