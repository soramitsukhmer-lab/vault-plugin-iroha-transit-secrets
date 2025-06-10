it:
	docker run --rm -it -p 8200:8200 -v $(PWD)/plugins:/plugins \
		hashicorp/vault:1.17 server \
			-config=/plugins/config.hcl \
			-dev \
			-dev-root-token-id=toor
