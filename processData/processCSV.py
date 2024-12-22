import csv
import random
import sys
import re
from faker import Faker

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

def check_for_emojis(text):

    try:
        # Define a regex pattern to check for emojis (basic emoji blocks)
        emoji_pattern = re.compile(
            '[\U0001F600-\U0001F64F'  # emoticons
            '\U0001F300-\U0001F5FF'  # symbols and pictographs
            '\U0001F680-\U0001F6FF'  # transport and map symbols
            '\U0001F700-\U0001F77F'  # alchemical symbols
            '\U0001F780-\U0001F7FF'  # Geometric Shapes Extended
            '\U0001F800-\U0001F8FF'  # Supplemental Arrows-C
            '\U0001F900-\U0001F9FF'  # Supplemental Symbols and Pictographs
            '\U0001FA00-\U0001FA6F'  # Chess Symbols
            '\U0001FA70-\U0001FAFF'  # Symbols and Pictographs Extended-A
            '\U00002702-\U000027B0'  # Dingbats
            ']+', flags=re.UNICODE)

        # Check if the text contains any emojis
        if emoji_pattern.search(text):
            a = 1
        else:
            a = 0

        return a
    except Exception as e:
        return 0

def addFakeNames(data,labels,percentage):

    fake = Faker()

    # Calculate the number of unique names needed based on the percentage
    total_rows = len(data)
    unique_names_count = int(total_rows * (1 - percentage))

    # Generate the required number of unique fake names
    unique_names = [fake.user_name() for _ in range(unique_names_count)]

    # Create a pool of names where some are repeated based on the percentage
    all_names = unique_names + random.choices(unique_names, k=total_rows - unique_names_count)
    random.shuffle(all_names)  # Shuffle to randomize the order of names

    # Add the new label to the labels list
    labels = ["user_names"] + labels

    # Add a fake name to each row of the dataset
    updated_data = []
    for row, name in zip(data, all_names):
        updated_data.append([name] + row)  # Prepend the fake name to the row

    return labels, updated_data

def write_csv(name, label, data):

    with open(name, 'a') as fout:
        # write label
        #fout.write('ª'.join(label) + '\n')
        # write data
        for row in data:
            #print(';'.join(row) + '\n')
            fout.write('ª'.join(row) + '\n')

def process_data(label, data, columns):
    # process data

    label = [label[col] for col in columns]
    data = [[row[col] for col in columns] for row in data]

    #data = [
    #    [
    #        re.sub(r'[^\sa-zA-Z0-9]', '', row[col])
    #        for col in columns
    #    ]
    #    for row in data
    #]
    return label, data

def prepare_data(data):
    # prepare data
    # 1 for good review
    # 0 for bad review

    new_data = []

    # remove rows with rating 3 or that have a empty field
    i = 0
    for row in data:
        i+=1
        rating = int(row[6])

        new_row = row
        score = 0

        if rating >= 3:
            score = 1

        new_row[5] = row[5].replace("ª","")
        #print(score)
        new_row[6] = str(score)

        if score == 0:
            new_data.append(new_row)
        #new_data.append(new_row)


    return new_data


if __name__ == '__main__':

    # get script call argument
    label,data = read_csv(sys.argv[1])
    if len(sys.argv) == 5:
        print("fake names...")
        label,data = addFakeNames(data,label,float(sys.argv[4]))
        print(label)
        print("done...")
    data = prepare_data(data)
    inds = list(map(int, sys.argv[2].split(',')))
    label,data = process_data(label,data,inds)
    write_csv(sys.argv[3],label,data)
