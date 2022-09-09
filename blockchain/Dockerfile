FROM eosio/eosio:v2.0.13

RUN mkdir /var/config

ADD ./config.ini /var/config/config.ini
ADD ./nodeos-stop.sh /bin/nodeos-stop.sh 

# command line only args from the chain plugin:
# disable-replay-opts
CMD nodeos\
    -e\
    -p eosio\
    --data-dir /data/data-dir\
    --config-dir /var/config\
    --disable-replay-opts