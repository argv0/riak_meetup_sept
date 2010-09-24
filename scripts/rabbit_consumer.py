from amqplib import client_0_8 as amqp
from sqlite3 import dbapi2 as sqlite
import json

AMQP_HOST = "localhost:5672"
AMQP_USER = "guest"
AMQP_PASS = "guest"
AMQP_VHOST = "/"
AMQP_QUEUE = "riak.publish"

DB_CONN = None

def connect():
    ''' Connect to RabbitMQ '''
    return amqp.Connection(
        host=AMQP_HOST,
        userid=AMQP_USER,
        password=AMQP_PASS,
        virtual_host=AMQP_VHOST,
        insist=False)

def save_obj(obj):
    ''' Save "obj" to database '''
    c = DB_CONN.cursor()
    c.execute("INSERT INTO goog_prices VALUES "
              "(%s,%s,%s,%s,%s,%s)" %
              (obj['date'],
               obj['open'],
               obj['high'],
               obj['low'],
               obj['volume'],
               obj['adj_close']))
    DB_CONN.commit()
    print "saved record for ", obj['date']

def recv_callback(msg):
    ''' Called on receipt of a RabbitMQ message '''
    obj = json.loads(json.loads(json.loads(msg.body.strip())))
    save_obj(obj)

def setup_db():
    DB_CONN.execute("CREATE TABLE goog_prices "
                    "(date, open, high, low, volume, close)")


def main():
    global DB_CONN
    DB_CONN = sqlite.connect("goog_prices")
    setup_db()
    amqp_conn = connect()
    amqp_chan = amqp_conn.channel()
    amqp_chan.basic_consume(
        queue=AMQP_QUEUE, 
        no_ack=True,
        callback=recv_callback, 
        consumer_tag="testtag")
    while True: amqp_chan.wait()


if __name__ == "__main__":
    main()
