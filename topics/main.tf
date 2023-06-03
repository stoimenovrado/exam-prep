terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-emit-app" {
  name = "shekeriev/rabbit-prod"
}

resource "docker_image" "img-recv-app" {
  name = "shekeriev/rabbit-cons"
}

resource "docker_container" "emit-app" {
  name  = "emit-container"
  image = docker_image.img-emit-app.image_id
  env = [
    "BROKER=rabbitmq-1",
    "BROKERPORT=5672",
    "EXCHANGE=prep"
    ]
  networks_advanced {
        name = "rabbitmq"
    }

    restart   = "always"

}

resource "docker_container" "recv-app" {
  name  = "recv-container"
  image = docker_image.img-recv-app.image_id
  env = [
    "BROKER=rabbitmq-1",
    "BROKERPORT=5672",
    "EXCHANGE=prep",
    "TOPICS=prep.*"
    ]
  networks_advanced {
        name = "rabbitmq"
    }

    restart   = "always"

}