import csv
import sys

def main():

    if len(sys.argv)!=3:
        print("script [file] [column]")


    file = sys.argv[1]
    column = int( sys.argv[2] )

    values = []

    with open( file, "r") as fin:
        reader = csv.reader(fin,delimiter="ª")
        next(reader)

        for row in reader:
            #print(row)
            values.append( int(row[column]) )

    unique = set(values)
    for i in unique:
        s = 0;
        for j in values:
          if j == i:
            s+=1

        print(f"{i}-> {s/len(values):.2f}")



if __name__ == "__main__":
    main()
