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
        kind = entry["componentTypeEn"].strip()
        new_entry = Component(
            name, brand, part_number, lcsc_part_number, description, package, kind
        )
        # if lcsc_part_number in table:
        #     print(f"Part {part_number} is a duplicate!")
        table[lcsc_part_number] = new_entry


def main(subdir="pages"):
    running_table = {}
    for filename in [f for f in os.listdir(subdir) if os.path.isfile(os.path.join(subdir, f))]:
    # for index in range(1, 25):
        with open(os.path.join(subdir, filename)) as f:
            append_entries(f, running_table)
        # with open(f"{subdir}/second-run-page-{index}.json") as f:
        #     append_entries(f, running_table)
        # with open(f"{subdir}/third-run-page-{index}.json") as f:
        #     append_entries(f, running_table)
        # with open(f"{subdir}/fourth-run-page-{index}.json") as f:
        #     append_entries(f, running_table)
        # with open(f"{subdir}/fifth-run-page-{index}.json") as f:
        #     append_entries(f, running_table)

    print(f"There are {len(running_table)} components")

    kinds = {}
    for entry in running_table.values():
        if entry.kind not in kinds:
            kinds[entry.kind] = []
        kinds[entry.kind].append(entry)

    kind_list = list(kinds.keys())
    kind_list.sort()
    for kind in kind_list:
        print(f"{kind}")
        entries = kinds[kind]
        entries.sort(key=lambda entry: entry.description)
        for entry in entries:
            print(
                f"    {entry.part_number}: {entry.description} -- {entry.brand} / {entry.lcsc_part_number}"
            )


if __name__ == "__main__":
    main()
