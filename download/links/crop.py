import os
import errno
import json
from pprint import pprint
import random


NUM_CLASSES = 100


def select(n, num_samples):
    if (num_samples > n):
        raise Exception("n is smaller than number of samples to select!")
    return random.sample(range(n), num_samples)


def main():
    _map = {}

    with open("ontology.json") as f:
        data = json.load(f)

    selected_classes = select(len(data), NUM_CLASSES)

    for _id in selected_classes:
        category_name = data[_id]["name"]
        category_id = data[_id]["id"]
        _map[category_name] = category_id

    src = 'original.csv'

    with open(src, 'r') as _in:
        content = _in.readlines()

        for category_name in _map.keys():
            dst = "../raw/{}/links.csv".format(category_name)
            category_id = _map[category_name]
            if not os.path.exists(os.path.dirname(dst)):
                try:
                    os.makedirs(os.path.dirname(dst))
                except OSError as exc:  # Guard against race condition
                    if exc.errno != errno.EEXIST:
                        raise

            with open(dst, 'w') as out:
                for row in content:
                    if (row.split()[3].startswith("\"" + category_id)):
                        out.write(row)


if __name__ == "__main__":
    main()
