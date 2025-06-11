variable "VERSION" {}

group "default" {
  targets = ["binaries"]
}

target "binaries" {
  args = {
      "VERSION" = "${VERSION}"
  }
  output = [ "./bin" ]
  platforms = [ "local" ]
  target = "binaries"
}
