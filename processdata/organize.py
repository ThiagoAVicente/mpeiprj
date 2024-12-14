import csv
import sys

def organize(data,col) -> list:
    # oraganizes data based on the "col" column

    new_data = []
    rows0 = []
    rows1 = []

    for row in data:

        # get label
        label = int(row[col])
        if label == 0:
            rows0.append(row)
            continue
        rows1.append(row)

    i0 = 0
    i1 = 0

    while i0 < len(rows0) or i1 < len(rows1):
        if i0 < len(rows0):
            new_data.append( rows0[i0] )
            i0 += 1
        if i1 < len(rows1):
            new_data.append( rows1[i1] )
            i1 += 1

    return new_data


def main():
    file = sys.argv[1]
    col = int(sys.argv[2])

    data = []
    label = []

    print("reading...")
    with open( file, "r") as fin:
        reader = csv.reader(fin,delimiter="ª")
        label = next(reader)

        for row in reader:
            data.append(row)

    print(f"organizing based on column {col}...")
    new_data = organize(data,col)

    print(f"saving on {sys.argv[3]}...")
    with open ( sys.argv[3],"a") as fou:

        fou.write('ª'.join(label) + '\n')

        for row in new_data:
            fou.write('ª'.join(row) + '\n')


if __name__ == "__main__":
    main()
