terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-rabbitmq" {
    name = "rabbitmq:3.11-management"
}

resource "docker_network" "rabbitmq" {
  name   = "rabbitmq"
  driver = "bridge"
}

resource "docker_container" "rabbitmq-1" {
    name     = "rabbitmq-1"
    image    = docker_image.img-rabbitmq.image_id
    hostname = "rabbitmq-1"

    ports {
        internal = 15672
        external = 8080
    }

    networks_advanced {
        name = "rabbitmq"
    }

    volumes {
        container_path  = "/config/"
        host_path       = "${path.cwd}/rabbitmq/node-1/"
        read_only       = false
    }

    env = [
    "RABBITMQ_CONFIG_FILE=/config/rabbitmq",
    "RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP"
    ]

    restart   = "on-failure"

}
