@echo off
set xv_path=D:\\Program\\xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xsim tb_led_flow_behav -key {Behavioral:sim_1:Functional:tb_led_flow} -tclbatch tb_led_flow.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
