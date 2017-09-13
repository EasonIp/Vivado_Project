@echo off
set xv_path=D:\\Program\\xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xelab  -wto aa9b0c1c78de4ccb8c789678b237c42f -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_led_flow_behav xil_defaultlib.tb_led_flow xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
