onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FSM_tb/CLK_50M
add wave -noupdate /FSM_tb/sync_clock_22khz
add wave -noupdate /FSM_tb/flash_mem_waitrequest
add wave -noupdate /FSM_tb/flash_mem_readdatavalid
add wave -noupdate /FSM_tb/flash_mem_readdata
add wave -noupdate /FSM_tb/flash_mem_read
add wave -noupdate /FSM_tb/flash_mem_address
add wave -noupdate -expand -group DATA /FSM_tb/audio_out
add wave -noupdate -expand -group DATA /FSM_tb/FSM_LOGIC/audio_out
add wave -noupdate /FSM_tb/audio_data
add wave -noupdate /FSM_tb/FSM_LOGIC/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {16 ps} {122 ps}
