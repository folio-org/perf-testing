import os
import re
import random
from pymarc import MARCReader, MARCWriter, Field


def process_file(input_file_path, output_file_path):
    with open(input_file_path, 'rb') as infile:
        with open(output_file_path, 'wb') as outfile:
            reader = MARCReader(infile)
            writer = MARCWriter(outfile)

            for record in reader:

                field_010 = record.get_fields('010')

                if field_010:

                    field_010_value = field_010[0]['a']
                    print("Исходное значение подполя 'a':", field_010_value)

                    new_value = random.randrange(1000000000, 10000000000)
                    print("Новое значение подполя 'new_value':", new_value)

                    field_010[0]['a'] = f'n  02{new_value} '

                    print(
                        "Новое значение подполя 'field_010[0]':", field_010[0])

                writer.write(record)

            reader.close()
            writer.close()


current_directory = os.getcwd()


output_folder = os.path.join(current_directory, 'output')


if not os.path.exists(output_folder):
    os.makedirs(output_folder)


for filename in os.listdir(current_directory):

    if filename.endswith('.mrc'):
        input_file_path = os.path.join(current_directory, filename)
        output_filename = os.path.splitext(
            filename)[0] + '_new.mrc'  # Создаем новое имя файла
        output_file_path = os.path.join(output_folder, output_filename)
        process_file(input_file_path, output_file_path)
