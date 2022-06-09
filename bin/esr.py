#!/usr/bin/env python3
def ifsc_decode(ifsc):
    # FIXME This is only for data aborts
    ifsc_table = {
            0b000000: 'Address size fault in TTBR0 or TTBR1.',
            0b000101: 'Translation fault, 1st level.',
            0b00110: 'Translation fault, 2nd level.',
            0b00111: 'Translation fault, 3rd level.',
            0b001001: 'Access flag fault, 1st level.',
            0b001010: 'Access flag fault, 2nd level.',
            0b001011: 'Access flag fault, 3rd level.',
            0b001101: 'Permission fault, 1st level.',
            0b001110: 'Permission fault, 2nd level.',
            0b001111: 'Permission fault, 3rd level.',
            0b010000: 'Synchronous external abort.',
            0b011000: 'Synchronous parity error on memory access.',
            0b010101: 'Synchronous external abort on translation table walk, 1st level.',
            0b010110: 'Synchronous external abort on translation table walk, 2nd level.',
            0b010111: 'Synchronous external abort on translation table walk, 3rd level.',
            0b011101: 'Synchronous parity error on memory access on translation table walk, 1st level.',
            0b011110: 'Synchronous parity error on memory access on translation table walk, 2nd level.',
            0b011111: 'Synchronous parity error on memory access on translation table walk, 3rd level.',
            0b100001: 'Alignment fault.',
            0b100010: 'Debug event.',
            }
    return ifsc_table.get(ifsc)

def ec_decode(ec):
    ec_table = {
            0b000000: ("Unknown reason.","ISS encoding for exceptions with an unknown reason"),
            0b000001: ("Trapped WF* instruction execution. Conditional WF* instructions that fail their condition code check do not cause an exception.","ISS encoding for an exception from a WF* instruction"),
            0b000011: ("Trapped MCR or MRC access with (coproc==0b1111) that is not reported using EC 0b000000.","ISS encoding for an exception from an MCR or MRC access","When AArch32 is supported at EL0"),
            0b000100: ("Trapped MCRR or MRRC access with (coproc==0b1111) that is not reported using EC 0b000000.","ISS encoding for an exception from an MCRR or MRRC access","When AArch32 is supported at EL0"),
            0b000101: ("Trapped MCR or MRC access with (coproc==0b1110).","ISS encoding for an exception from an MCR or MRC access","When AArch32 is supported at EL0"),
            0b000110: ("Trapped LDC or STC access. The only architected uses of these instruction are: An STC to write data to memory from DBGDTRRXint. An LDC to read data from memory to DBGDTRTXint." "ISS encoding for an exception from an LDC or STC instruction","When AArch32 is supported at EL0"),
            0b000111: ("Access to SVE"," Advanced SIMD or floating-point functionality trapped by CPACR_EL1.FPEN"," CPTR_EL2.FPEN"," CPTR_EL2.TFP"," or CPTR_EL3.TFP control. Excludes exceptions resulting from CPACR_EL1 when the value of HCR_EL2.TGE is 1"," or because SVE or Advanced SIMD and floating-point are not implemented. These are reported with EC value 0b000000 as described in 'The EC used to report an exception routed to EL2 because HCR_EL2.TGE is 1'.","ISS encoding for an exception from an access to SVE"," Advanced SIMD or floating-point functionality"," resulting from the FPEN and TFP traps"),
            0b001010: ("Trapped execution of an LD64B"," ST64B"," ST64BV"," or ST64BV0 instruction.","ISS encoding for an exception from an LD64B or ST64B* instruction","When FEAT_LS64 is implemented"),
            0b001100: ("Trapped MRRC access with (coproc==0b1110).","ISS encoding for an exception from an MCRR or MRRC access","When AArch32 is supported at EL0"),
            0b001101: ("Branch Target Exception.","ISS encoding for an exception from Branch Target Identification instruction","When FEAT_BTI is implemented"),
            0b001110: ("Illegal Execution state.","ISS encoding for an exception from an Illegal Execution state"," or a PC or SP alignment fault"),
            0b010001: ("SVC instruction execution in AArch32 state.","ISS encoding for an exception from HVC or SVC instruction execution","When AArch32 is supported at EL0"),
            0b010101: ("SVC instruction execution in AArch64 state.","ISS encoding for an exception from HVC or SVC instruction execution","When AArch64 is supported at the highest implemented Exception level"),
            0b011000: ("Trapped MSR"," MRS or System instruction execution in AArch64 state"," that is not reported using EC 0b000000"," 0b000001"," or 0b000111. This includes all instructions that cause exceptions that are part of the encoding space defined in 'System instruction class encoding overview'"," except for those exceptions reported using EC values 0b000000"," 0b000001"," or 0b000111.","ISS encoding for an exception from MSR"," MRS"," or System instruction execution in AArch64 state","When AArch64 is supported at the highest implemented Exception level"),
            0b011001: ("Access to SVE functionality trapped as a result of CPACR_EL1.ZEN"," CPTR_EL2.ZEN"," CPTR_EL2.TZ"," or CPTR_EL3.EZ"," that is not reported using EC 0b000000.","ISS encoding for an exception from an access to SVE functionality"," resulting from CPACR_EL1.ZEN"," CPTR_EL2.ZEN"," CPTR_EL2.TZ"," or CPTR_EL3.EZ","When FEAT_SVE is implemented"),
            0b011100: ("Exception from a Pointer Authentication instruction authentication failure","ISS encoding for an exception from a Pointer Authentication instruction authentication failure","When FEAT_FPAC is implemented"),
            0b100000: ("Instruction Abort from a lower Exception level. Used for MMU faults generated by instruction accesses and synchronous External aborts"," including synchronous parity or ECC errors. Not used for debug-related exceptions.","ISS encoding for an exception from an Instruction Abort"),
            0b100001: ("Instruction Abort taken without a change in Exception level. Used for MMU faults generated by instruction accesses and synchronous External aborts"," including synchronous parity or ECC errors. Not used for debug-related exceptions.","ISS encoding for an exception from an Instruction Abort"),
            0b100010: ("PC alignment fault exception.","ISS encoding for an exception from an Illegal Execution state"," or a PC or SP alignment fault"),
            0b100100: ("Data Abort from a lower Exception level. Used for MMU faults generated by data accesses"," alignment faults other than those caused by Stack Pointer misalignment"," and synchronous External aborts"," including synchronous parity or ECC errors. Not used for debug-related exceptions.","ISS encoding for an exception from a Data Abort"),
            0b100101: ("Data Abort taken without a change in Exception level. Used for MMU faults generated by data accesses"," alignment faults other than those caused by Stack Pointer misalignment"," and synchronous External aborts"," including synchronous parity or ECC errors. Not used for debug-related exceptions.","ISS encoding for an exception from a Data Abort"),
            0b100110: ("SP alignment fault exception.","ISS encoding for an exception from an Illegal Execution state"," or a PC or SP alignment fault"),
            0b101000: ("Trapped floating-point exception taken from AArch32 state. This EC value is valid if the implementation supports trapping of floating-point exceptions"," otherwise it is reserved. Whether a floating-point implementation supports trapping of floating-point exceptions is IMPLEMENTATION DEFINED.","ISS encoding for an exception from a trapped floating-point exception","When AArch32 is supported at EL0"),
            0b101100: ("Trapped floating-point exception taken from AArch64 state. This EC value is valid if the implementation supports trapping of floating-point exceptions"," otherwise it is reserved. Whether a floating-point implementation supports trapping of floating-point exceptions is IMPLEMENTATION DEFINED.","ISS encoding for an exception from a trapped floating-point exception","When AArch64 is supported at the highest implemented Exception level"),
            0b101111: ("SError interrupt.","ISS encoding for an SError interrupt"),
            0b110000: ("Breakpoint exception from a lower Exception level.","ISS encoding for an exception from a Breakpoint or Vector Catch debug exception"),
            0b110001: ("Breakpoint exception taken without a change in Exception level.","ISS encoding for an exception from a Breakpoint or Vector Catch debug exception"),
            0b110010: ("Software Step exception from a lower Exception level.","ISS encoding for an exception from a Software Step exception"),
            0b110011: ("Software Step exception taken without a change in Exception level.","ISS encoding for an exception from a Software Step exception"),
            0b110100: ("Watchpoint exception from a lower Exception level.","ISS encoding for an exception from a Watchpoint exception"),
            0b110101: ("Watchpoint exception taken without a change in Exception level.","ISS encoding for an exception from a Watchpoint exception"),
            0b111000: ("BKPT instruction execution in AArch32 state.","ISS encoding for an exception from execution of a Breakpoint instruction","When AArch32 is supported at EL0"),
            0b111100: ("BRK instruction execution in AArch64 state.","ISS encoding for an exception from execution of a Breakpoint instruction","When AArch64 is supported at the highest implemented Exception level"),            
            }
    return ec_table.get(ec)[0]

def esr_decode(esr):
    ec = (esr >> 26) & 0x3f
    il = (esr >> 25) & 1
    ea = (esr >> 9) & 1
    s1ptw = (esr >> 7) & 1
    ifsc = (esr >> 0) & 0x3f
    print('esr', esr, hex(esr))
    print('ec', hex(ec), bin(ec), ec_decode(ec))
    print('il', il)
    print('ea', ea)
    print('s1ptw', s1ptw)
    print('ifsc', hex(ifsc), ifsc_decode(ifsc))

if __name__ == '__main__':
    import sys
    esr_decode(int(sys.argv[1], 0))

