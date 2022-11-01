print("Hello!")

import os
import pandas as pd
import dpkt
import socket

import warnings
warnings.simplefilter('ignore')

directory="/var/experiment_logs/tcpdump"


#df = pd.DataFrame(columns=["container", "ip", "time"])
dfs = {}

for root, dirs, files in os.walk(directory):
    c = os.path.basename(root)
    # Remember, we're getting IP and time :)
    # Very fun fact: all destinations are just our IPs. We only need sources!
    counter=0
    httpcounter=0
    https=0
    srs = {}
    ips=[]
    time=[]
    for f in files:
        for ts, pkt in dpkt.pcap.Reader(open(os.path.join(root,f), "rb")):
            counter+=1
            eth = dpkt.ethernet.Ethernet(pkt)
            ip = eth.data
            tcp = ip.data
            source = socket.inet_ntoa(ip.src)
            dest = socket.inet_ntoa(ip.dst)

            if source in srs:
                srs[source] += 1
            else:
                srs[source] = 1

            if tcp.dport == 80:
                httpcounter+=1
                ips.append(source)
                time.append(ts)

            elif tcp.sport == 80:
                https+=1
    dfs[c] = pd.DataFrame({"ip": ips, "time": time}, columns=["ip", "time"])
    dfs[c]["container"] = c

    print("In", c, "there were", counter, "total packets.", httpcounter, "were to http and", https, "were from https.")
    print(dfs[c].head())

df = pd.concat(list(dfs.values()))
print(df.head())
df.to_csv("tcpdump_output.csv")
