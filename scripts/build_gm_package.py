#!/usr/bin/env python3
"""Build a GameMaker import package (.yyp + .yyz) from repository GML scripts.

This creates a lightweight GameMaker project that imports script assets from:
- Scripts/*.gml
- scripts/gamemaker/scripts/*.gml

It also adds raw Objects/ and Rooms/ as Included Files so event snippets are
available inside the imported project for manual event wiring.
"""

from __future__ import annotations

import json
import shutil
import uuid
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "gm_package"
PROJECT_NAME = "ld_character_game"
PROJECT_FILE = f"{PROJECT_NAME}.yyp"

SCRIPT_SOURCES = [
    ROOT / "Scripts",
    ROOT / "scripts" / "gamemaker" / "scripts",
]

INCLUDED_DIRS = [
    ROOT / "Objects",
    ROOT / "Rooms",
    ROOT / "dataset",
]


def write_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def new_guid() -> str:
    return str(uuid.uuid4())


def gather_script_files() -> list[Path]:
    scripts: list[Path] = []
    for src in SCRIPT_SOURCES:
        if src.exists():
            scripts.extend(sorted(src.glob("*.gml")))
    # Deduplicate by script stem, preferring files from the first source.
    dedup: dict[str, Path] = {}
    for p in scripts:
        dedup.setdefault(p.stem, p)
    return sorted(dedup.values(), key=lambda p: p.stem.lower())


def build_script_resources(script_files: list[Path]) -> list[dict]:
    resources: list[dict] = []
    scripts_root = OUT_DIR / "scripts"

    for src in script_files:
        script_name = src.stem
        script_dir = scripts_root / script_name
        script_dir.mkdir(parents=True, exist_ok=True)

        # GameMaker expects code in scripts/<name>/<name>.gml.
        gm_code = script_dir / f"{script_name}.gml"
        gm_code.write_text(src.read_text(encoding="utf-8"), encoding="utf-8")

        script_yy = {
            "$GMScript": "v1",
            "%Name": script_name,
            "isCompatibility": False,
            "isDnD": False,
            "name": script_name,
            "parent": {
                "name": "Scripts",
                "path": "folders/Scripts.yy",
            },
            "resourceType": "GMScript",
            "resourceVersion": "2.0",
        }
        write_json(script_dir / f"{script_name}.yy", script_yy)

        resources.append(
            {
                "id": {
                    "name": script_name,
                    "path": f"scripts/{script_name}/{script_name}.yy",
                }
            }
        )

    return resources


def copy_included_files() -> list[dict]:
    included_entries: list[dict] = []
    included_root = OUT_DIR / "datafiles"

    for source_dir in INCLUDED_DIRS:
        if not source_dir.exists():
            continue

        rel_name = source_dir.name
        dest_dir = included_root / rel_name
        if dest_dir.exists():
            shutil.rmtree(dest_dir)
        shutil.copytree(source_dir, dest_dir)

        for f in dest_dir.rglob("*"):
            if not f.is_file():
                continue
            rel = f.relative_to(OUT_DIR).as_posix()
            included_entries.append(
                {
                    "$GMIncludedFile": "",
                    "%Name": f.name,
                    "CopyToMask": -1,
                    "filePath": rel,
                    "name": f.name,
                    "resourceType": "GMIncludedFile",
                    "resourceVersion": "2.0",
                    "tags": [],
                }
            )

    return included_entries


def build_project(script_resources: list[dict], included_files: list[dict]) -> None:
    default_folder = {
        "$GMFolder": "",
        "%Name": "Default",
        "children": [
            {
                "name": "Scripts",
                "path": "folders/Scripts.yy",
            }
        ],
        "filterType": "root",
        "folderPath": "folders/Default.yy",
        "name": "Default",
        "resourceType": "GMFolder",
        "resourceVersion": "2.0",
    }

    scripts_folder = {
        "$GMFolder": "",
        "%Name": "Scripts",
        "children": [r["id"] for r in script_resources],
        "filterType": "GMScript",
        "folderPath": "folders/Scripts.yy",
        "name": "Scripts",
        "resourceType": "GMFolder",
        "resourceVersion": "2.0",
    }

    write_json(OUT_DIR / "folders" / "Default.yy", default_folder)
    write_json(OUT_DIR / "folders" / "Scripts.yy", scripts_folder)

    # Minimal required options file.
    write_json(
        OUT_DIR / "options" / "main" / "options_main.yy",
        {
            "$GMMainOptions": "",
            "%Name": "Main",
            "name": "Main",
            "option_author": "",
            "option_collision_compatibility": False,
            "option_copy_on_write_enabled": True,
            "option_draw_colour": 4294967295,
            "option_gameguid": new_guid(),
            "option_gameid": 0,
            "option_mips_for_3d_textures": False,
            "option_sci_usesci": False,
            "option_spine_licence": False,
            "option_steam_app_id": "0",
            "option_template_description": "",
            "option_template_icon": "",
            "option_template_image": "",
            "option_window_colour": 255,
            "resourceType": "GMMainOptions",
            "resourceVersion": "2.0",
        },
    )

    project = {
        "$GMProject": "v1",
        "%Name": PROJECT_NAME,
        "AudioGroups": [
            {
                "$GMAudioGroup": "",
                "%Name": "audiogroup_default",
                "name": "audiogroup_default",
                "targets": -1,
                "resourceType": "GMAudioGroup",
                "resourceVersion": "2.0",
            }
        ],
        "configs": {"children": [{"name": "Default"}], "name": "Default"},
        "defaultScriptType": 1,
        "Folders": [
            {"name": "Default", "path": "folders/Default.yy"},
            {"name": "Scripts", "path": "folders/Scripts.yy"},
        ],
        "IncludedFiles": included_files,
        "MetaData": {
            "IDEVersion": "2024.8.1.218",
            "PackageType": "yyp",
            "PackageName": "com.ld.character",
            "PackageDisplayName": PROJECT_NAME,
            "AppID": new_guid(),
            "UseAudioGroupDefault": True,
        },
        "name": PROJECT_NAME,
        "resources": script_resources,
        "resourceType": "GMProject",
        "resourceVersion": "2.0",
        "RoomOrderNodes": [],
        "TextureGroups": [
            {
                "$GMTextureGroup": "",
                "%Name": "Default",
                "autocrop": True,
                "border": 2,
                "compressFormat": "bz2",
                "isScaled": True,
                "loadType": 0,
                "mipsToGenerate": 0,
                "name": "Default",
                "resourceType": "GMTextureGroup",
                "resourceVersion": "2.0",
                "targets": -1,
            }
        ],
    }

    write_json(OUT_DIR / PROJECT_FILE, project)


def build_yyz() -> Path:
    yyz_path = ROOT / f"{PROJECT_NAME}.yyz"
    if yyz_path.exists():
        yyz_path.unlink()

    with ZipFile(yyz_path, "w", compression=ZIP_DEFLATED) as zf:
        for f in OUT_DIR.rglob("*"):
            if f.is_file():
                arcname = f.relative_to(OUT_DIR).as_posix()
                zf.write(f, arcname)

    return yyz_path


def main() -> None:
    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    OUT_DIR.mkdir(parents=True)

    script_files = gather_script_files()
    script_resources = build_script_resources(script_files)
    included_files = copy_included_files()
    build_project(script_resources, included_files)
    yyz_path = build_yyz()

    print(f"Created project: {OUT_DIR / PROJECT_FILE}")
    print(f"Created archive: {yyz_path}")
    print(f"Script assets packaged: {len(script_resources)}")
    print(f"Included files packaged: {len(included_files)}")


if __name__ == "__main__":
    main()
