set shell := ["bash", "-c"]

# EXPORT the directory so Bash can read it as an environment variable
export INVOKE_DIR := invocation_directory()

# Update the snippet to use the Bash variable (htu "$INVOKE_DIR")
check_context := '''
    cd "$INVOKE_DIR"
    if [ ! -f "pack.toml" ]; then
        echo "- Error: No 'pack.toml' found in current path."
        echo "- Current path: $INVOKE_DIR"
        echo "- Please 'cd' into a specific version folder to run this."
        exit 1
    fi
    echo "== Context: $(basename "$PWD")"
'''

_default:
    @just --list

# List All Mods
[group('develop')]
list:
    #!/usr/bin/bash
    {{check_context}}
    packwiz list

# Refresh Modpack
[group('develop')]
refresh:
    #!/usr/bin/bash
    {{check_context}}
    packwiz refresh

# Update All Mods
[group('develop')]
update:
    #!/usr/bin/bash
    {{check_context}}
    packwiz update --all

# Start up Dev Server
[group('test')]
server-up:
    #!/usr/bin/bash
    {{check_context}}
    podman compose up -d

# Stop Dev Server
[group('test')]
server-stop:
    #!/usr/bin/bash
    {{check_context}}
    podman compose stop

# Remove Dev Server Container
[group('test')]
server-rm:
    #!/usr/bin/bash
    {{check_context}}
    podman compose rm -s -f

# Export Modpack to pack.mrpack
[group('deploy')]
export:
    #!/usr/bin/bash
    {{check_context}}
    packwiz modrinth export -o pack.mrpack
