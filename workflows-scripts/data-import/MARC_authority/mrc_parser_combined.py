#!/usr/bin/env python3
"""Prepare MARC authority files for FOLIO performance tests.

For every .mrc file in the current directory, this script:
1. Replaces the first 010 $a value with a newly generated value, preserving
   the behavior of the previous parser.
2. Splits any 667 field containing more than one $a into separate 667 fields,
   because 667 $a is non-repeatable and can cause FOLIO to concatenate the
   authority noteTypeId UUID more than once.
3. Writes the resulting file to ./output/<original_name>_new.mrc.

Requires pymarc 5.x:
    python -m pip install pymarc
"""

from __future__ import annotations

import argparse
import copy
import random
from pathlib import Path
from typing import Iterable

from pymarc import Field, MARCReader, MARCWriter, Subfield


def generate_010_value(used_values: set[str]) -> str:
    """Generate a unique 010 $a value for the current script run."""
    while True:
        value = f"n  02{random.randrange(1_000_000_000, 10_000_000_000)} "
        if value not in used_values:
            used_values.add(value)
            return value


def replace_first_010_a(record, used_values: set[str]) -> tuple[bool, str | None, str | None]:
    """Replace the first 010 $a, matching the behavior of the old parser."""
    fields_010 = record.get_fields("010")
    if not fields_010:
        return False, None, None

    field_010 = fields_010[0]
    old_value = field_010.get("a")
    if old_value is None:
        return False, None, None

    new_value = generate_010_value(used_values)
    field_010["a"] = new_value
    return True, old_value, new_value


def clone_non_a_subfields(field: Field) -> list[Subfield]:
    """Copy all non-$a subfields so qualifiers remain attached to each note."""
    return [copy.copy(sf) for sf in field.subfields if sf.code != "a"]


def split_repeated_667_a(record) -> int:
    """Split every 667 with multiple $a values into separate 667 fields.

    Returns the number of original 667 fields that were split.
    """
    split_count = 0

    # Iterate over a copy because record.fields is modified below.
    for field in list(record.get_fields("667")):
        a_values = field.get_subfields("a")
        if len(a_values) <= 1:
            continue

        original_index = record.fields.index(field)
        non_a_subfields = clone_non_a_subfields(field)
        replacement_fields: list[Field] = []

        for value in a_values:
            replacement_fields.append(
                Field(
                    tag="667",
                    indicators=list(field.indicators),
                    subfields=[Subfield(code="a", value=value)]
                    + [copy.copy(sf) for sf in non_a_subfields],
                )
            )

        record.remove_field(field)
        for offset, replacement in enumerate(replacement_fields):
            record.fields.insert(original_index + offset, replacement)

        split_count += 1

    return split_count


def process_file(
    input_path: Path,
    output_path: Path,
    used_010_values: set[str],
    verbose: bool = False,
) -> dict[str, int]:
    """Process one MARC file and return counters."""
    stats = {
        "records_read": 0,
        "records_written": 0,
        "records_with_010_changed": 0,
        "records_with_667_fixed": 0,
        "fields_667_split": 0,
        "invalid_records": 0,
    }

    with input_path.open("rb") as infile, output_path.open("wb") as outfile:
        reader = MARCReader(
            infile,
            to_unicode=True,
            force_utf8=True,
            utf8_handling="replace",
            permissive=True,
        )
        writer = MARCWriter(outfile)

        try:
            for record_number, record in enumerate(reader, start=1):
                stats["records_read"] += 1

                if record is None:
                    stats["invalid_records"] += 1
                    print(f"WARNING: {input_path.name}, record {record_number}: could not be parsed; skipped")
                    continue

                changed_010, old_010, new_010 = replace_first_010_a(record, used_010_values)
                if changed_010:
                    stats["records_with_010_changed"] += 1

                split_count = split_repeated_667_a(record)
                if split_count:
                    stats["records_with_667_fixed"] += 1
                    stats["fields_667_split"] += split_count

                if verbose and (changed_010 or split_count):
                    control_number = record["001"].value() if record["001"] else "no 001"
                    details = []
                    if changed_010:
                        details.append(f"010 $a: {old_010!r} -> {new_010!r}")
                    if split_count:
                        details.append(f"split {split_count} repeated 667 field(s)")
                    print(
                        f"{input_path.name}: record {record_number}, 001={control_number}: "
                        + "; ".join(details)
                    )

                writer.write(record)
                stats["records_written"] += 1
        finally:
            writer.close()

    return stats


def find_input_files(directory: Path) -> Iterable[Path]:
    """Return .mrc files directly in the selected directory."""
    return sorted(path for path in directory.iterdir() if path.is_file() and path.suffix.lower() == ".mrc")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Regenerate authority 010 $a values and split repeated 667 $a subfields."
    )
    parser.add_argument(
        "directory",
        nargs="?",
        default=".",
        help="Directory containing source .mrc files (default: current directory)",
    )
    parser.add_argument(
        "--output-dir",
        default="output",
        help="Output folder name or path (default: output)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print details for every changed record",
    )
    args = parser.parse_args()

    source_directory = Path(args.directory).resolve()
    if not source_directory.is_dir():
        parser.error(f"Directory does not exist: {source_directory}")

    output_directory = Path(args.output_dir)
    if not output_directory.is_absolute():
        output_directory = source_directory / output_directory
    output_directory.mkdir(parents=True, exist_ok=True)

    input_files = list(find_input_files(source_directory))
    if not input_files:
        print(f"No .mrc files found in: {source_directory}")
        return 1

    used_010_values: set[str] = set()
    total = {
        "files": 0,
        "records_read": 0,
        "records_written": 0,
        "records_with_010_changed": 0,
        "records_with_667_fixed": 0,
        "fields_667_split": 0,
        "invalid_records": 0,
    }

    for input_path in input_files:
        output_path = output_directory / f"{input_path.stem}_new.mrc"
        print(f"Processing: {input_path.name}")

        stats = process_file(input_path, output_path, used_010_values, args.verbose)
        total["files"] += 1
        for key, value in stats.items():
            total[key] += value

        print(
            f"Created: {output_path}\n"
            f"  records written: {stats['records_written']}\n"
            f"  010 $a changed: {stats['records_with_010_changed']}\n"
            f"  records with repeated 667 $a fixed: {stats['records_with_667_fixed']}\n"
            f"  original 667 fields split: {stats['fields_667_split']}\n"
            f"  invalid records skipped: {stats['invalid_records']}"
        )

    print(
        "\nCompleted.\n"
        f"  files processed: {total['files']}\n"
        f"  records written: {total['records_written']}\n"
        f"  010 $a changed: {total['records_with_010_changed']}\n"
        f"  records with repeated 667 $a fixed: {total['records_with_667_fixed']}\n"
        f"  original 667 fields split: {total['fields_667_split']}\n"
        f"  invalid records skipped: {total['invalid_records']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
