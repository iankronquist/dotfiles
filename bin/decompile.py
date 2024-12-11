#!/opt/homebrew/Caskroom/ghidra/11.1.2-20240709/ghidra_11.1.2_PUBLIC/support/pythonRun

from  ghidra.app.decompiler import DecompInterface
from ghidra.util.task import ConsoleTaskMonitor

# get the current program
# here currentProgram is predefined
currentProgram = '/Users/ian/gg/pitayaos/build/iphoneos.internal/sym/roottask.AOP_T8132.DEVELOPMENT.sym'

program = currentProgram
decompinterface = DecompInterface()
decompinterface.openProgram(program);
functions = program.getFunctionManager().getFunctions(True)
for function in list(functions):
    print(function)
    # decompile each function
    tokengrp = decompinterface.decompileFunction(function, 0, ConsoleTaskMonitor())
    print(tokengrp.getDecompiledFunction().getC())
