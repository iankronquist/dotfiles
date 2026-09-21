# GPT-5 — Thinking: disabled — Date: 2025-08-13
# LLDB Python helpers for debugging CPython interpreter internals.
# Ported from classic ~/.gdbinit Python macros.

import lldb
import sys

def pyo(debugger, command, result, internal_dict):
    """Dump a PyObject* using _PyObject_Dump."""
    target = debugger.GetSelectedTarget()
    expr = f"(void)_PyObject_Dump((PyObject*){command})"
    target.EvaluateExpression(expr)

def pyg(debugger, command, result, internal_dict):
    """Dump a PyGC_Head* using _PyGC_Dump."""
    target = debugger.GetSelectedTarget()
    expr = f"_PyGC_Dump((PyGC_Head*){command})"
    target.EvaluateExpression(expr)

def pylocals(debugger, command, result, internal_dict):
    """Print local variables of the current Python frame (frame->f_localsplus)."""
    frame = debugger.GetSelectedTarget().GetProcess().GetSelectedThread().GetSelectedFrame()
    f = frame.EvaluateExpression("f").GetValueAsUnsigned()
    if not f:
        result.AppendMessage("No 'f' in current frame.")
        return

    nlocals = frame.EvaluateExpression("f->f_code->co_nlocals").GetValueAsUnsigned()
    for i in range(nlocals):
        name_expr = f"_PyUnicode_AsString(PyTuple_GetItem(f->f_code->co_varnames, {i}))"
        name_val = frame.EvaluateExpression(name_expr).GetSummary()
        val_expr = f"f->f_localsplus[{i}]"
        val_val = frame.EvaluateExpression(val_expr)
        result.AppendMessage(f"{name_val}:")
        pyo(debugger, val_expr, result, internal_dict)

def pyframe(debugger, command, result, internal_dict):
    """Print current Python frame info."""
    frame = debugger.GetSelectedTarget().GetProcess().GetSelectedThread().GetSelectedFrame()
    fn = frame.EvaluateExpression("_PyUnicode_AsString(co->co_filename)").GetSummary()
    name = frame.EvaluateExpression("_PyUnicode_AsString(co->co_name)").GetSummary()
    lineno_expr = "/* Implement lineno logic here if desired */"
    result.AppendMessage(f"{fn}: {name}")

def pu(debugger, command, result, internal_dict):
    """Print a PyUnicode* string."""
    target = debugger.GetSelectedTarget()
    expr = f"_PyUnicode_AsString((PyObject*){command})"
    s = target.EvaluateExpression(expr).GetSummary()
    result.AppendMessage(s)

def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('command script add -f lldb_python_debug.pyo pyo')
    debugger.HandleCommand('command script add -f lldb_python_debug.pyg pyg')
    debugger.HandleCommand('command script add -f lldb_python_debug.pylocals pylocals')
    debugger.HandleCommand('command script add -f lldb_python_debug.pyframe pyframe')
    debugger.HandleCommand('command script add -f lldb_python_debug.pu pu')
    print("Loaded Python LLDB debugging commands: pyo, pyg, pylocals, pyframe, pu")

