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

    set {
      name = "grafana.ingress.enabled"
      value = "true"
    }

    set {
      name = "grafana.ingress.ingressClassName"
      value = "nginx"
    }

    set {
      name = "grafana.persistence.enabled"
      value = "true"
    }

    set {
      name = "grafana.persistence.type"
      value = "pvc"
    }

    set {
      name = "grafana.persistence.storageClassName"
      value = "grafana-data"
    }

    set {
      name = "grafana.persistence.size"
      value = "2Gi"
    } 

    depends_on = [
      kubernetes_namespace.monitoring
    ]
}