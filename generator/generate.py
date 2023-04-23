import csv
import os
from random import randrange, choice
from json import dump
import psycopg2
from psycopg2.extras import execute_values

from assets import PRODUCTS, ALL_DAYS,CHANNELS, get_channel_distribution,FIRST_NAMES, LAST_NAMES, CSV_RESELLERS, JSON_RESELLERS, RESELLERS_TRANSACTIONS, random_date

CONNECTION = psycopg2.connect(user=os.environ["POSTGRES_USER"],
                                password=os.environ["POSTGRES_PASSWORD"],
                                host="oltp",
                                port="5432",
                                database="sales_oltp")


def generate_oltp(n=1000000):
    print('Generating transactions')

    trans = []

    for i in range(n):

        product = choice(PRODUCTS)
        
        bought = random_date()
        boughtdate = str(bought)

        qty = randrange(1,6)

        transaction = {'customer_id': randrange(1,100000),
                       'product_id': product['product_id'],
                       'amount': product['price'] * qty,
                       'qty': qty,
                       'channel_id': choice([i['channel_id'] for i in CHANNELS]),
                       'bought_date': boughtdate }

        trans.append(transaction)
    return trans


def insert_oltp_transactions():
    print('Inserting transactions')

    trans = generate_oltp()

    columns = trans[0].keys()

    with CONNECTION as conn:
        cur = conn.cursor()

        cur.execute("DROP TABLE IF EXISTS transactions")
        cur.execute("CREATE TABLE transactions(transaction_id serial primary key, customer_id int, product_id int, amount money, qty int, channel_id int, bought_date date )")

        query = "INSERT INTO transactions({}) VALUES %s".format(','.join(columns))

        # convert projects values to sequence of sequences
        values = [[value for value in tran.values()] for tran in trans]

        execute_values(cur, query, values)

        conn.commit()


def insert_oltp_resellers():
    print('Inserting resellers')


    columns = RESELLERS_TRANSACTIONS[0].keys()

    with CONNECTION as conn:
        cur = conn.cursor()


        cur.execute("DROP TABLE IF EXISTS resellers")
        cur.execute("CREATE TABLE resellers(reseller_id int, reseller_name VARCHAR(255), commission_pct decimal)")

        query = "INSERT INTO resellers({}) VALUES %s".format(','.join(columns))

        # convert projects values to sequence of seqeences
        values = [[value for value in tran.values()] for tran in RESELLERS_TRANSACTIONS]

        execute_values(cur, query, values)

        conn.commit()


def insert_oltp_channels():
    print('Inserting channels')

    columns = CHANNELS[0].keys()

    with CONNECTION as conn:
        cur = conn.cursor()


        cur.execute("DROP TABLE IF EXISTS channels")
        cur.execute("CREATE TABLE channels(channel_id int, channel_name VARCHAR(255))")

        query = "INSERT INTO channels({}) VALUES %s".format(','.join(columns))

        # convert projects values to sequence of seqeences
        values = [[value for value in tran.values()] for tran in CHANNELS]

        execute_values(cur, query, values)

        conn.commit()


def insert_oltp_customers():
    print('Inserting customers')

    trans = []
    for i in range(100000):
        first_name = choice(FIRST_NAMES)
        last_name = choice(LAST_NAMES)
        trans.append({'customer_id': i, 'first_name': first_name , 'last_name': last_name, 'email': f'{first_name}.{last_name}@example.com' })

    columns = trans[0].keys()

    with CONNECTION as conn:
        cur = conn.cursor()


        cur.execute("DROP TABLE IF EXISTS customers")
        cur.execute("CREATE TABLE customers(customer_id int, first_name VARCHAR(255), last_name VARCHAR(255), email VARCHAR(255))")

        query = "INSERT INTO customers({}) VALUES %s".format(','.join(columns))

        values = [[value for value in tran.values()] for tran in trans]

        execute_values(cur, query, values)

        conn.commit()


def insert_oltp_products():
    print('Inserting products')

    trans = PRODUCTS
    
    columns = trans[0].keys()

    with CONNECTION as conn:
        cur = conn.cursor()


        cur.execute("DROP TABLE IF EXISTS products")
        cur.execute("CREATE TABLE products(product_id int, name VARCHAR(255), city VARCHAR(255), price money)")

        query = "INSERT INTO products({}) VALUES %s".format(','.join(columns))

        values = [[value for value in tran.values()] for tran in trans]

        execute_values(cur, query, values)

        conn.commit()


def generate_csv(resellerid, n=50000):
    print('Generating CSV data')
    export = []

    for i in range(n): 

        product = choice(PRODUCTS)

        qty = randrange(1,7)

        boughtdate = str(random_date())

        first_name = choice(FIRST_NAMES)
        last_name = choice(LAST_NAMES)

        transaction = {
                    'Product name': product['name'],
                    'Quantity':  qty,
                    'Total amount': qty * product['price'],
                    'Sales Channel': choice(get_channel_distribution('reseller')),
                    'Customer First Name': first_name,
                    'Customer Last Name': last_name,
                    'Customer Email': f'{first_name}.{last_name}@example.com',
                    'Series City': product['city'],
                    'Created Date': boughtdate,
                    'Reseller ID' : resellerid
                     
                     
                      }

        export.append(transaction)
    return export


def insert_csv():
    print('Inserting CSV data')

    for resellerid in CSV_RESELLERS:

        export = generate_csv(resellerid)

        keys = ['Transaction ID']+ list(export[0].keys()) 

        tran_id = 0


        for day in ALL_DAYS:

            data = [tran for tran in export if tran['Created Date']== day]

            for entry in data:
                entry['Transaction ID'] = tran_id
                tran_id += 1

            date_nameformat = day.split('-')
            new_format = date_nameformat[0] + date_nameformat[2] + date_nameformat[1]


            with open(f"/shared/csv/DailySales_{new_format}_{resellerid}.csv", 'w', newline='')  as output_file:
                dict_writer = csv.DictWriter(output_file, keys)
                dict_writer.writeheader()
                dict_writer.writerows(data)


def generate_json(resellerid, n = 50000 ):
    print('Generating JSON data')
    export = []

    for i in range(n):

        product = choice(PRODUCTS)

        qty = randrange(1,7)

        bought = random_date()

        boughtdate = str(bought).replace('-','')

        first_name = choice(FIRST_NAMES)
        last_name = choice(LAST_NAMES)

        transaction = {
                    'date': boughtdate,
                    'reseller-id':resellerid,
                    'productName': product['name'],
                    'qty' : qty,
                    'totalAmount': qty * product['price'] * 1.0,
                    'salesChannel': choice(get_channel_distribution('reseller')),
                    'customer': {'firstname': first_name, 'lastname': last_name, 'email': f'{first_name}.{last_name}@example.com' },
                    'dateCreated': boughtdate,
                    'seriesCity': product['city'],
                    'Created Date': str(bought)
                    }

        export.append(transaction)
    return export


def insert_json():
    print('Inserting JSON data')

    for resellerid in JSON_RESELLERS:

        tran_id = 0

        export = generate_json(resellerid)

        for day in ALL_DAYS:

            data = [tran for tran in export if tran['Created Date']== day]

            for entry in data:
                entry['transactionId'] = tran_id
                tran_id += 1

            date_nameformat = day.split('-')
            new_format = date_nameformat[0] + date_nameformat[2] + date_nameformat[1]

            with open(f"/shared/json/rawDailySales_{new_format}_{resellerid}.json", 'w')  as output_file:
                dump(data, output_file)

def cleanup(directory, ext):

    import os

    filelist = [ f for f in os.listdir(directory) if f.endswith(ext) ]
    for f in filelist:
        os.remove(os.path.join(directory, f))


cleanup('/shared/json', 'json')
cleanup('/shared/csv', 'csv')
insert_oltp_channels()
insert_oltp_customers()
insert_oltp_products()
insert_oltp_resellers()
insert_oltp_transactions()
insert_csv()
insert_json()