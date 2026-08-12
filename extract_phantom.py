import sys
sys.stdout.reconfigure(encoding='utf-8')

from xdis import load_module

ver, timestamp, magic_int, co, is_pypy, source_size, sip_hash = load_module(
    'apk_src/ninja_sage_android/core/monster_hunting.pyc'
)

def find_code_objects(code_obj, depth=0):
    results = []
    results.append((depth, code_obj))
    for const in code_obj.co_consts:
        if hasattr(const, 'co_name'):
            results.extend(find_code_objects(const, depth + 1))
    return results

all_codes = find_code_objects(co)

for depth, c in all_codes:
    if c.co_name == '<module>':
        print("FOUND <module>")
        print(f"Constants:")
        for i, const in enumerate(c.co_consts):
            if not hasattr(const, 'co_name'):
                s = repr(const)
                if len(s) > 200:
                    s = s[:200] + "..."
                print(f"  [{i}]: {s}")
        print("=" * 80)
