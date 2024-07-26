repositories = [
  {
    name = "WeatherForecast"
  },
  {
    name = "spring-boot-newrelic"
  },
  {
    name = "jenkins-api"
  },
  {
    name = "jenkins-api-postman-tests"
  },
  {
    name = "roadmaps"
  },
  {
    name = "getting-started-app"
  },
  {
    name = "labs-devops-challenges"
  },
  {
    name = "robot-friend"
  },
  {
    name = "marublaize"
  },
  {
    name = "Datapi-DevOps-Challenge"
  },
  {
    name = "rede-cnpj"
  },
  {
    name = "mysql-ansible"
  },
  {
    name = "exemplo-jean"
  },

  {
    name = "k3s-minio-deployment"
  },
  {
    name = "lwps"
  },
  {
    name = "devops-challenge-20221219"
  },
  {
    name = "lw-go-scripts"
  },
  {
    name = "node-toy-scrape"
  },
  {
    name = "desafio-devops"
  },
  {
    name = "devops-assessment"
  },
  {
    name = "deploy-to-s3-leo"
  },
  {
    name = "simpleapp-python"
  },
  {
    name = "zabbix-docker"
  },
  {
    name = "nginx-dynatrace"
  },
  {
    name = "telefonica-vivo-brasil-demo2"
  },
  {
    name = "telefonica-vivo-brasil-demo"
  },
  {
    name = "sql_conn"
  },
  {
    name = "express-cosmosdb"
  },
  {
    name = "nr-ext-api-test"
  },
  {
    name        = "up-and-running-jenkins"
    description = "Reference code for the blog / video tutorial of Up and Running with Lacework and Jenkins"
  },
  {
    name = "fourkeys"
  },
  {
    name = "prom-grafana-demo"
  },
  {
    name = "debian-nginx-demo"
  },

  {
    name = "linux-tips-and-tricks"
  },
  {
    name = "devops"
  },
  {
    name = "pure-bash-bible"
  },
  {
    name = "labsdevops.com.br"
    pages = {
      branch = "master"
      path   = "/"
    }
  },
  {
    name = "desafios"
  },
  {
    name = "nodejs-posgresql"
  },
  {
    name = "desafio"
  },
  {
    name = "dockerfiles"
  },
  {
    name = "arch-setup"
  },
  {
    name = "microk8s-aws"
  },
  {
    name = "k3s-ansible"
  },
  {
    name = "ansible-kubernetes-ha-cluster"
  },
  {
    name = "php-fpm"
  }
]

teams = [
  # {
  #   name        = "example-team-1"
  #   description = "This is an example team 1"
  #   privacy     = "closed"
  #   members     = ["user1", "user2"]
  # }
]

environments = {
  development = {
    repositories = []
    secrets = {
      SECRET_KEY = "dev_secret_value"
    }
  },
  staging = {
    repositories = []
    secrets = {
      SECRET_KEY = "stg_secret_value"
    }
  },
  production = {
    repositories = []
    secrets = {
      SECRET_KEY = "prod_secret_value"
    }
  }
}
