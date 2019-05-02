# prometheus-confd

This project hielps you to dynamically update prometheus configuration using Consul backend to provide dynamically updated infrastructure configs. Confd fetches updated configs from consul and updates Prometheus targets at run-time. All you need to do id modify the supervisor.conf to reflect your consul servers IP.

git clone https://github.com/iamrawtion/prometheus-confd.git

cd prometheus-confd

docker build .
