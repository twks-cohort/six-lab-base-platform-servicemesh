#!/usr/bin/env bash

export DOMAIN=$1
export CLUSTER=$2

cat <<EOF > ./nginx.conf
events {
}

http {
  log_format main '$remote_addr - $remote_user [$time_local]  $status '
  '"$request" $body_bytes_sent "$http_referer" '
  '"$http_user_agent" "$http_x_forwarded_for"';
  access_log /var/log/nginx/access.log main;
  error_log  /var/log/nginx/error.log;

  server {
    listen 443 ssl;

    root /usr/share/nginx/html;
    index index.html;

    server_name nginx.example.com;
    ssl_certificate /etc/domain-certificate/tls.crt;
    ssl_certificate_key /etc/domain-certificate/tls.key;
  }
}
EOF

kubectl create configmap -n istio-system nginx-configmap --from-file=nginx.conf=./nginx.conf

cat <<EOF > nginx_server.yaml
apiVersion: v1
kind: Service
metadata:
  name: test-nginx
  namespace: istio-system
  labels:
    run: test-nginx
spec:
  ports:
  - port: 443
    protocol: TCP
  selector:
    run: test-nginx
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: test-nginx
  namespace: istio-system
spec:
  hosts:
  - nginx.${DOMAIN}
  gateways:
  - istio-system/${CLUSTER}-cdicohorts-six-com-gateway
  tls:
  - match:
    - port: 443
      sniHosts:
      - nginx.${DOMAIN}
    route:
    - destination:
        host: test-nginx.istio-system.svc.cluster.local
        port:
          number: 443
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-nginx
  namespace: istio-system
spec:
  selector:
    matchLabels:
      run: test-nginx
  replicas: 1
  template:
    metadata:
      labels:
        run: test-nginx
        sidecar.istio.io/inject: "true"
    spec:
      containers:
      - name: test-nginx
        image: nginx
        ports:
        - containerPort: 443
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx
          readOnly: true
        - name: domain-certificate
          mountPath: /etc/domain-certificate
          readOnly: true
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-configmap
      - name: domain-certificate
        secret:
          secretName: ${DOMAIN}-certificate
EOF

kubectl apply -f nginx_server.yaml
