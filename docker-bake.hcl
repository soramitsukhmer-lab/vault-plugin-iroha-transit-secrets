variable "VERSION" {
  default = "latest"
}

target "default" {
  tags = [
    "soramitsukhmer-lab/vault-plugin-iroha-transit-secrets:${VERSION}"
  ]
}

target "binaries" {
  args = {
      "VERSION" = "${VERSION}"
  }
  output = [ "./bin" ]
  platforms = [ "local" ]
  target = "binaries"
}
