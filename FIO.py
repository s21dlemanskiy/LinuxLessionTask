import pandas as pd
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--index", default=None)
    parser.add_argument("-p", "--path", default=None)
    args = parser.parse_args()
    if args.path is None:
        file_path = input("file_path:")
    else:
        file_path = args.path
    if args.index is None:
        index_of_names_col = int(input("index_of_names_col:"))
    else:
        index_of_names_col = int(args.index)
    df = pd.read_excel(file_path, header=None)
    last_col = max(df.columns)
    df[last_col + 1] = df[index_of_names_col].apply(lambda x: list(x.split(" "))[0])
    df[last_col + 2] = df[index_of_names_col].apply(lambda x: list(x.split(" "))[1])
    df[last_col + 3] = df[index_of_names_col].apply(lambda x: list(x.split(" "))[2])
    df[last_col + 4] = df[index_of_names_col].apply(lambda x: f"{list(x.split(' '))[2]} {list(x.split(' '))[0][0].upper()}.{list(x.split(' '))[1][0].upper()}.")
    df.to_excel(file_path, index=False, header=None)