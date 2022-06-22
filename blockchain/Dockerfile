FROM eostudio/eos:v2.0.7

RUN mkdir /var/config

ADD ./config.ini /var/config/config.ini
ADD ./stop.sh /bin/stop.sh 

# command line only args from the chain plugin:
# disable-replay-opts
CMD nodeos\
    -e\
    -p eosio\
    --data-dir /data/data-dir\
    --config-dir /var/config\
    --disable-replay-opts