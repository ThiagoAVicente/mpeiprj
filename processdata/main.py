import csv
import sys
import re

def read_csv(name):

    # Read the CSV file
    data = []
    label = []

    with open(name, 'r') as fin:
        # read label
        label = fin.readline().strip().split(',')
        # read data
        data = list(csv.reader(fin))

    return label, data

def write_csv(name, label, data):

    with open(name, 'w') as fout:
        # write label
        fout.write(','.join(label) + '\n')
        # write data
        for row in data:
            fout.write(','.join(row) + '\n')

def process_data(label, data, columns):
    # process data

    label = [label[col] for col in columns]
    data = [
        [
            re.sub(r'[^\sa-zA-Z0-9]', '', row[col])
            for col in columns
        ]
        for row in data
    ]
    return label, data

def prepare_data(data):
    # prepare data
    # 1 for good review
    # 0 for bad review

    new_data = []

    # remove rows with rating 3 or that have a empty field
    for row in data:

        rating = int(row[3])

        if rating == 3 or '' in row:
            continue

        new_row = row
        score = 0

        if rating > 3:
            score = 1

        new_row[3] = str(score)
        new_data.append(new_row)


    return new_data


if __name__ == '__main__':

    # get script call argument
    label,data = read_csv(sys.argv[1])
    data = prepare_data(data)
    inds = list(map(int, sys.argv[2].split(',')))
    label,data = process_data(label,data,inds)
    write_csv(sys.argv[3],label,data)
