import struct

def read_mrc_file(file_path):
    with open(file_path, 'rb') as file:
        return file.read()

def write_mrc_file(file_path, data):
    with open(file_path, 'wb') as file:
        file.write(data)

def read_replacement_strings(file_path):
    with open(file_path, 'r') as file:
        return [line.strip() for line in file.readlines()]

def replace_string_in_chunks(data, old_str, new_str_list, chunk_size=1000):
    old_str_bytes = old_str.encode()
    new_data = bytearray(data)
    occurrences = [i for i in range(len(data)) if data.startswith(old_str_bytes, i)]
    
    for i, start in enumerate(occurrences):
        if i >= len(new_str_list) * chunk_size:
            break
        new_str = new_str_list[i // chunk_size].encode()
        end = start + len(old_str_bytes)
        new_data[start:end] = new_str
    
    return new_data

def main():
    mrc_file_path = 'path_to_file/5k_holdings.mrc'  # Path to your MRC file

    output_file_path = 'path_to_file/5k_holdings_changed.mrc'  # Path to save the modified MRC file
    replacement_strings_file_path = 'path_to_file/stringsHRID.txt'  # Path to your file with replacement strings
    old_str = 'colin00001144043'  # String to be replaced

    # Read the MRC file
    data = read_mrc_file(mrc_file_path)

    # Read the replacement strings from file
    new_str_list = read_replacement_strings(replacement_strings_file_path)

    # Replace strings in chunks
    modified_data = replace_string_in_chunks(data, old_str, new_str_list)

    # Write the modified data to a new MRC file
    write_mrc_file(output_file_path, modified_data)

if __name__ == "__main__":
    main()
