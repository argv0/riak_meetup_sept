import csv, json
import riak

DATA_FILE="goog.csv"

def munge(r):
    return dict(
        date=r['Date'],
        volume=r['Volume'],
        adj_close=r['Adj Close'],
        open=r['Open'],
        high=r['High'],
        low=r['Low'])

def main():
    client = riak.RiakClient()
    bucket = client.bucket("goog_prices")
    fp = file(DATA_FILE, "rbU")
    reader = csv.reader(fp)
    h = reader.next()
    count = 0
    for line in reader:
        record = munge(dict(zip(h, line)))
        obj = bucket.new(record['date'])
        obj.set_data(json.dumps(record))
        obj.store()
        count += 1
    print "stored %s objects" % count

if __name__ == "__main__":
    main()
