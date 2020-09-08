import winreg
import sys
import os

JIT_DEBUGGER_KEY = 'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\AeDebug'
JIT_WOW64_DEBUGGER_KEY = 'SOFTWARE\\WOW6432Node\\Microsoft\\Windows NT\\CurrentVersion\\AeDebug'
JIT_DEBUGGER_LEAF = 'Debugger'

DEBUGGERS = {
        'vs': '"{}\\system32\\vsjitdebugger.exe" -p %ld -e %ld'.format(os.environ['SYSTEMROOT']),
        'windbg': '"{}\\dbg\\ui\\WinDbgX.exe" -p %ld -e %ld -g'.format(os.environ['LOCALAPPDATA']),
        'none': ''
}

def get_key(hive, key, leaf):
    hkey = winreg.OpenKey(hive, key, 0, winreg.KEY_READ)
    value, key_type = winreg.QueryValueEx(hkey, leaf)
    winreg.CloseKey(hkey)
    return value, key_type

def set_key(hive, key, leaf, value):
    hkey = winreg.OpenKey(hive, key, 0, winreg.KEY_WRITE)
    winreg.SetValueEx(hkey, leaf, 0, winreg.REG_SZ, value)
    winreg.CloseKey(hkey)

def show_help():
    script_name = sys.argv[0]
    print('''{} [DEBUGGER_TYPE]
    If no arguments are given, show the debugger type.
    DEBUGGER_TYPE must be one of: {}
    '''.format(script_name, ', '.join(DEBUGGERS.keys())))

if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('Current JIT Debugger value:')
        print(get_key(winreg.HKEY_LOCAL_MACHINE, JIT_DEBUGGER_KEY, JIT_DEBUGGER_LEAF)[0])
        print('Current WOW64 JIT Debugger value:')
        print(get_key(winreg.HKEY_LOCAL_MACHINE, JIT_WOW64_DEBUGGER_KEY, JIT_DEBUGGER_LEAF)[0])
    elif len(sys.argv) == 2 and sys.argv[1] in DEBUGGERS.keys():
        set_key(winreg.HKEY_LOCAL_MACHINE, JIT_DEBUGGER_KEY, JIT_DEBUGGER_LEAF, DEBUGGERS[sys.argv[1]])
        set_key(winreg.HKEY_LOCAL_MACHINE, JIT_WOW64_DEBUGGER_KEY, JIT_DEBUGGER_LEAF, DEBUGGERS[sys.argv[1]])
    else:
        show_help()


