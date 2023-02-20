resource "helm_release" "common" {
  name = "common-resources"

  chart      = "../../../../kubernetes/common"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
