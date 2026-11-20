#!/zynthian/venv/bin/python

import os
import sys

sys.path.insert(0, os.environ.get('ZYNTHIAN_UI_DIR', '/zynthian/zynthian-ui'))
sys.path.insert(0, os.environ.get('ZYNTHIAN_WEBCONF_DIR', '/zynthian/zynthian-webconf'))

import zynconf
from lib.extrapacks_handler import ExtraPacksHandler

zynconf.load_config()

# Create instance without calling Tornado's RequestHandler.__init__
handler = ExtraPacksHandler.__new__(ExtraPacksHandler)


def print_usage():
    print(f"Usage: {sys.argv[0]} <INFO|INSTALL|UNINSTALL|UPDATE> [<cat_name> <package_name>]")

if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 4:
        print_usage()
        sys.exit(1)

    cmd = sys.argv[1].upper()
    try:
        cat_name = sys.argv[2]
        pack_name = sys.argv[3]
    except:
        cat_name = None
        pack_name = None


    if cat_name and pack_name:
        info = handler.get_package(cat_name, pack_name)
        if info:
            handler.pack_info =  {
                cat_name: { pack_name: info }
            }
            print(f"{cmd} '{cat_name}/{pack_name}' ...")
        else:
            sys.exit(1)
    else:
        if cmd == "INFO":
            info = handler.get_packages()
            print(f"{cmd} ...")
        else:
            print_usage()
            sys.exit(1)

    errors = None
    match cmd:
        case "INSTALL":
            try:
                errors = handler.do_install_package(pack_name)
            except Exception as err:
                errors = f"Can't install package {pack_name}.\n{err}"
        case "UNINSTALL":
            try:
                errors = handler.do_uninstall_package(pack_name)
            except Exception as err:
                errors = f"Can't uninstall package {pack_name}.\n{err}"
        case "UPDATE":
            try:
                errors = handler.do_uninstall_package(pack_name)
                if not errors:
                    errors = handler.do_install_package(pack_name)
            except Exception as err:
                errors = f"Can't update package {pack_name}.\n{err}"
        case "INFO":
            print(info)
        case _:
            print_usage()
            sys.exit(1)

    if errors:
        print(f"ERROR => {errors}")
    else:
        msg = cmd
        print("SUCCESS!")
