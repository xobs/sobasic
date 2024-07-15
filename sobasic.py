#!/usr/bin/env python

import dataclasses
import json
from typing import TextIO, List, Dict
import os

@dataclasses.dataclass
class Component:
    name: str
    brand: str
    part_number: str
    lcsc_part_number: str
    description: str
    package: str
    kind: str
    library_type: str
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
        name = entry["componentName"].strip()
        brand = entry["componentBrandEn"].strip()
        part_number = entry["componentModelEn"].strip()
        lcsc_part_number = entry["componentCode"].strip()
        description = entry["describe"].strip()
        package = entry["componentSpecificationEn"].strip()
        library_type = entry["componentLibraryType"].strip()
        kind = entry["componentTypeEn"].strip()
        stock = entry["stockCount"]
        new_entry = Component(
            name, brand, part_number, lcsc_part_number,
            description, package, kind, library_type, stock
        )
        # if lcsc_part_number in table:
        #     print(f"Part {part_number} is a duplicate!")
        table[lcsc_part_number] = new_entry


def main(subdir="pages"):
    running_table = {}
    for filename in [f for f in os.listdir(subdir) if os.path.isfile(os.path.join(subdir, f))]:
    # for index in range(1, 25):
        with open(os.path.join(subdir, filename)) as f:
            print("Reading", filename)
            append_entries(f, running_table)
        # with open(f"{subdir}/second-run-page-{index}.json") as f:
        #     append_entries(f, running_table)
        # with open(f"{subdir}/third-run-page-{index}.json") as f:
        #     append_entries(f, running_table)
        # with open(f"{subdir}/fourth-run-page-{index}.json") as f:
        #     append_entries(f, running_table)
        # with open(f"{subdir}/fifth-run-page-{index}.json") as f:
        #     append_entries(f, running_table)

    print(f"There are {len(running_table)} total components")
    print()

    kinds = {}
    for entry in running_table.values():
        if entry.kind not in kinds:
            kinds[entry.kind] = []
        kinds[entry.kind].append(entry)

    kind_list = list(kinds.keys())
    kind_list.sort()
    for in_stock in [True, False]:
        if in_stock == False:
            print()
            print("Out of stock items:")
        for kind in kind_list:
            entries = kinds[kind]
            entries.sort(key=lambda entry: (entry.part_number, entry.description, entry.brand, entry.lcsc_part_number))
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
                if entry.library_type == "base":
                    library_sigil = " *"
                print(
                    f"    {entry.part_number}: {entry.description} -- {entry.brand} / {entry.lcsc_part_number}{library_sigil}"
                )


if __name__ == "__main__":
    main()
