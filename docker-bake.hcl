variable "VERSION" {
  default = ""
}

target "default" {
  tags = [
    "soramitsukhmer-lab/vault-plugin-iroha-transit-secrets:dev"
  ]
}

target "binaries" {
  args = {
      "VERSION" = "${VERSION}"
  }
  output = [ "./binaries" ]
  platforms = [ "local" ]
  target = "binaries"
}
