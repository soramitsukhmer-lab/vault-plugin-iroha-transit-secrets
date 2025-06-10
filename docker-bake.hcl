group "default" {
  targets = ["binaries"]
}

target "binaries" {
    output = [ "./bin" ]
    platforms = [ "local" ]
    target = "binaries"
}
