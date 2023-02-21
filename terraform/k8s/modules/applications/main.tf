resource "helm_release" "app1" {
    name = "app1"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/app1/"

    set {
        name  = "service.type"
        value = "ClusterIP"
    }
}

resource "helm_release" "app2" {
    name = "app2"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/app2/"

    set {
        name  = "service.type"
        value = "ClusterIP"
    }
}


resource "helm_release" "app3" {
    name = "app3"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/app3/"

    set {
        name  = "service.type"
        value = "ClusterIP"
    }
}


resource "helm_release" "app4" {
    name = "app4"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/app4/"

    set {
        name  = "service.type"
        value = "ClusterIP"
    }
}


resource "helm_release" "nginx" {
    name = "web-server"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/nginx/"

    set {
        name  = "service.type"
        value = "ClusterIP"
    }

    depends_on = [
      helm_release.app1, helm_release.app2, helm_release.app3, helm_release.app4
    ]
}

resource "helm_release" "common" {
    name = "nginx-host"
    
    chart = "${dirname(dirname(dirname(dirname(abspath(path.module)))))}/kubernetes/common/"
    depends_on = [
      helm_release.app1, helm_release.app2, helm_release.app3, helm_release.app4, helm_release.nginx
    ]
}

