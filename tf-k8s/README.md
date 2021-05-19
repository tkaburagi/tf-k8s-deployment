# The Demo GKE Deployment

GKE上にNginxをデプロイするためのコンフィグレーション

## Diagram

![](https://raw.githubusercontent.com/tkaburagi/tfcb-allinone/main/gcp-k8s/diagram.png)


## Applied Policy

* `probe-validator`: Deploymentに`liveness Probe`の設定を強制 (hard-mandatory)
* `strategy-validator`: アップグレードのストラテジーで`RollingUpdata`のみを許可 (hard-mandatory)
* `port-change-restrictor`: Nginxの外向けのポートの変更を禁止 (hard-mandatory)


## Setninel Git Repos
* https://github.com/tkaburagi/sentinel-k8s-strategy
* https://github.com/tkaburagi/sentinel-k8s-probe