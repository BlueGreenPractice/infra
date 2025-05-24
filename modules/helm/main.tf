resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = var.namespace
  version    = "5.2.1"

  set = [{
    name  = "controller.serviceType"
    value = "LoadBalancer"
    },
    {
      name  = "controller.nodeSelector.role"
      value = "cicd"
    },
    {   
      name  = "controller.persistence.size"
      value = "5Gi"
    },
    {
      name  = "controller.resources.requests.cpu"
      value = "500m"
    },
    {
      name  = "controller.resources.requests.memory"
      value = "2Gi"
    }
  ]
}
