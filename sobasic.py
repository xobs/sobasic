#!/usr/bin/env python

import argparse
import dataclasses
import json
from typing import TextIO, Dict
from enum import Enum
import os
import sys


# The kind of component that JLCPCB considers this as
class Kind(Enum):
    ALL = 1
    BASIC = 2
    PREFERRED = 3


@dataclasses.dataclass
class Component:
    # name: str
    brand: str
    part_number: str
    lcsc_part_number: str
    description: str
    package: str
    kind: str
    library_type: Kind
    stock: int


def append_entries(f: TextIO, table: Dict[str, Component]):
    s = f.read()
    decoded_json = json.loads(s)
    if "data" not in decoded_json:
        print("Error: 'data' not found in decoded json")
        return
    if "componentPageInfo" not in decoded_json["data"]:
        print("Error: 'componentPageInfo' not in decoded json")
        return
    if "list" not in decoded_json["data"]["componentPageInfo"]:
        print("Error: 'list' not in decoded json")
        return
    for entry in decoded_json["data"]["componentPageInfo"]["list"]:
        # name = entry["componentName"].strip()
        brand = entry["componentBrandEn"].strip()
        part_number = entry["componentModelEn"].strip()
        lcsc_part_number = entry["componentCode"].strip()
        description = entry["describe"].strip()
        package = entry["componentSpecificationEn"].strip()
        library_type = entry["componentLibraryType"].strip()
        kind = entry["componentTypeEn"].strip()
        stock = entry["stockCount"]

        if library_type == "base":
            library_type = Kind.BASIC
        elif entry["preferredComponentFlag"]:
            library_type = Kind.PREFERRED
        elif library_type == "expand":
            library_type = Kind.ALL
        else:
            raise Exception(f"Unknown library type: {library_type}")
        new_entry = Component(
            brand,
            part_number,
            lcsc_part_number,
            description,
            package,
            kind,
            library_type,
            stock,
        )
        # if lcsc_part_number in table:
        #     print(f"Part {part_number} is a duplicate!")
        table[lcsc_part_number] = new_entry


def main(subdir="pages", kind: Kind = Kind.ALL):
    running_table = {}

    # Fetch all components into `running_table`
    for filename in [
        f for f in os.listdir(subdir) if os.path.isfile(os.path.join(subdir, f))
    ]:
        with open(os.path.join(subdir, filename)) as f:
            print("Reading", filename, file=sys.stderr)
            append_entries(f, running_table)

    component_count = 0
    kinds = {}
    for entry in running_table.values():
        if (kind == Kind.PREFERRED) and (entry.library_type == Kind.ALL):
            continue
        if (kind == Kind.BASIC) and (entry.library_type != Kind.BASIC):
            continue
        component_count += 1
        if entry.kind not in kinds:
            kinds[entry.kind] = []
        kinds[entry.kind].append(entry)

    print(f"There are {component_count} total components")
    print()

    kind_list = list(kinds.keys())
    kind_list.sort()
    for in_stock in [True, False]:
        if in_stock == False:
            print()
            print("Out of stock items:")
        for kind in kind_list:
            entries = kinds[kind]
            entries.sort(
                key=lambda entry: (
                    entry.part_number,
                    entry.description,
                    entry.brand,
                    entry.lcsc_part_number,
                )
            )
            entry_count = 0
            for entry in entries:
                if (entry.stock == 0) == in_stock:
                    continue
                entry_count += 1
            if entry_count == 0:
                continue
            print(f"{kind}")
            for entry in entries:
                if (entry.stock == 0) == in_stock:
                    continue

                library_sigil = ""
                if entry.library_type == Kind.BASIC:
                    library_sigil = " *"
                elif entry.library_type == Kind.PREFERRED:
                    library_sigil = " **"

                stock_string = ""
                if entry.stock != 0:
                    stock_string = f" ({entry.stock})"
                print(
                    f"    {entry.part_number}: {entry.description} -- {entry.brand} / {entry.lcsc_part_number}{library_sigil}{stock_string}"
                )

def parse_kind(kind: str) -> Kind:
    if kind == "all":
        return Kind.ALL
    elif kind == "basic":
        return Kind.BASIC
    elif kind == "preferred":
        return Kind.PREFERRED
    else:
        raise Exception(f"Unknown kind: {kind}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--subdir", type=str, default="pages")
    parser.add_argument("--kind", type=parse_kind, default=Kind.ALL)
    parser.add_argument("--output", type=argparse.FileType('w', encoding='utf-8'))
    args = parser.parse_args()
    main(args.subdir, args.kind)
