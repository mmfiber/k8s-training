# 可用性
### ControlPlane 
#### ControlPlaneは分離できているか
現状は cluster.yaml のみ。
template を作成し、 stage ごとにクラスターを作るれるようにする。

#### 本番環境の ControlPlane は複数ノードで複製されているか
region を分けて作成可能な状態にしている。
金銭的な問題で node は一つしか立てていない。 
node が落ちた時に、別の region に node が立つかテストはできていない。テスト方法も考えられていない。

### アプリケーション
#### アプリケーションのスケールアウト設定は考慮されているか
* hpa
  * [自動的に設定されている](https://kops.sigs.k8s.io/horizontal_pod_autoscaling/)
  * [metrics](https://kops.sigs.k8s.io/horizontal_pod_autoscaling/#support-for-multiple-metrics)
