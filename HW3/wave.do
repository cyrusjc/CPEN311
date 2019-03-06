onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /INTERMEDIATE_MODULE_TB/clk
add wave -noupdate /INTERMEDIATE_MODULE_TB/in_recieved_data
add wave -noupdate /INTERMEDIATE_MODULE_TB/fsma_start
add wave -noupdate /INTERMEDIATE_MODULE_TB/fsma_start_trap
add wave -noupdate /INTERMEDIATE_MODULE_TB/start_target_state_machine
add wave -noupdate /INTERMEDIATE_MODULE_TB/recieved_data_a
add wave -noupdate /INTERMEDIATE_MODULE_TB/finish_a
add wave -noupdate /INTERMEDIATE_MODULE_TB/target_state_machine_finished
add wave -noupdate /INTERMEDIATE_MODULE_TB/reset_from_intermediate_a
add wave -noupdate /INTERMEDIATE_MODULE_TB/fsmb_start
add wave -noupdate /INTERMEDIATE_MODULE_TB/fsmb_start_trap
add wave -noupdate /INTERMEDIATE_MODULE_TB/recieved_data_b
add wave -noupdate /INTERMEDIATE_MODULE_TB/finish_b
add wave -noupdate /INTERMEDIATE_MODULE_TB/reset_from_intermediate_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 354
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
WaveRestoreZoom {0 ps} {230 ps}
