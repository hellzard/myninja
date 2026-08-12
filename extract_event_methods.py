import sys
sys.stdout.reconfigure(encoding='utf-8')

from xdis import load_module

ver, timestamp, magic_int, co, is_pypy, source_size, sip_hash = load_module(
    'apk_src/ninja_sage_android/core/event.pyc'
)

target_methods = [
    '_create_battle_hash',
    'fight_event',
]

def find_code_objects(code_obj, depth=0):
    results = []
    results.append((depth, code_obj))
    for const in code_obj.co_consts:
        if hasattr(const, 'co_name'):
            results.extend(find_code_objects(const, depth + 1))
    return results

all_codes = find_code_objects(co)

for depth, c in all_codes:
    if c.co_name in target_methods:
        print("=" * 80)
        print(f"METHOD: {c.co_name} (line {c.co_firstlineno})")
        print(f"Args: {c.co_varnames[:c.co_argcount]}")
        print(f"All locals: {c.co_varnames}")
        print(f"Constants:")
        for i, const in enumerate(c.co_consts):
            if not hasattr(const, 'co_name'):
                s = repr(const)
                if len(s) > 200:
                    s = s[:200] + "..."
                print(f"  [{i}]: {s}")
            else:
                print(f"  [{i}]: <code {const.co_name}>")
        print(f"Names: {c.co_names}")
        print("=" * 80)
        
        bc = c.co_code
        i = 0
        import opcode as op_module
        while i < len(bc):
            op = bc[i]
            arg = bc[i+1] if i + 1 < len(bc) else 0
            opname = op_module.opname[op] if op < len(op_module.opname) else f"<{op}>"
            
            arg_str = ""
            if op >= op_module.HAVE_ARGUMENT:
                if op in op_module.hasconst:
                    val = c.co_consts[arg] if arg < len(c.co_consts) else "?"
                    if hasattr(val, 'co_name'):
                        arg_str = f"= <code {val.co_name}>"
                    else:
                        s = repr(val)
                        if len(s) > 100: s = s[:100] + "..."
                        arg_str = f"= {s}"
                elif op in op_module.hasname:
                    val = c.co_names[arg] if arg < len(c.co_names) else "?"
                    arg_str = f"= {val}"
                elif op in op_module.haslocal:
                    val = c.co_varnames[arg] if arg < len(c.co_varnames) else "?"
                    arg_str = f"= {val}"
                else:
                    arg_str = f"({arg})"
            
            print(f"  {i:4d}  {opname:<25s} {arg:3d}  {arg_str}")
            i += 2
        print()
