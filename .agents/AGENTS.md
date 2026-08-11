# Ninja Sage API Project Guidelines

## Core Reference Truth
- **Strict Rule**: Always use the original APK decompiled code (`app-release-1-5-5.apk` and its extracted/decompiled outputs like `leveling_dis.txt`, `ninjasage_client_dis.txt`, etc.) as the ABSOLUTE main reference and single source of truth for all game mechanics, AMF endpoints, parameter structures, and logic implementation in this project.
- **Location**: These decompiled references are located in the `apk_src` directory (e.g., `C:\Users\acer\ZCodeProject\ninjasage-api\apk_src\`).
- If there is any discrepancy between the bot's behavior and the expected game behavior, trace the logic precisely through the Python bytecode in the `apk_src` disassembly files.
