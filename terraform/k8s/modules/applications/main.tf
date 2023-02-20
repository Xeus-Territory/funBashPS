resource "helm_release" "app4" {
  name = "app4"
  chart      = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/app4"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
