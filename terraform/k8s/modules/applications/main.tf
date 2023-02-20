resource "helm_release" "main" {
    name = "app1"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/app1/"

    set {
        name  = "service.type"
        value = "ClusterIP"
    }
}