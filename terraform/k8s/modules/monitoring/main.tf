resource "kubernetes_namespace" "monitoring" {
    metadata {
      name = var.metadata-namespace
    }
}

resource "helm_release" "prometheus" {
    name = "prometheus-stack"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "kube-prometheus-stack"

    values = [ 
      <<EOF
        kubeEtcd:
          enabled: false
        kubeControllerManager:
          enabled: false
        kubeScheduler:
          enabled: false
        kubeProxy:
          enabled: false
        alertmanager:
          alertmanagerSpec:
            storage:
              volumeClaimTemplate:
                spec:
                  storageClassName: alert-data
                  accessModes: ["ReadWriteOnce"]
                  resources:
                    requests:
                      storage: 1Gi
        
        prometheus:
          prometheusSpec:
            storageSpec:
              volumeClaimTemplate:
                spec:
                  storageClassName: prometheus-data
                  accessModes: ["ReadWriteOnce"]
                  resources:
                    requests:
                      storage: 1Gi
        grafana:
          ingress:
            enabled: true
            ingressClassName: nginx
      EOF
     ]

    depends_on = [
      kubernetes_namespace.monitoring
    ]
}