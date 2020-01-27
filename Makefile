#CFG_BINDINGS=go
#GENERATOR_IMAGE=openapitools/openapi-generator-cli
#GENERATOR=docker run --name oas --rm -v ${PWD}:/local ${GENERATOR_IMAGE}
SWAGGER_CLI_IMAGE=wwl1999/swagger-cli
VALIDATER=docker run --name openapivalidate --rm -v ${PWD}:/tmp ${SWAGGER_CLI_IMAGE}
BUNDLER=docker run --name openapibundle --rm -v ${PWD}:/tmp ${SWAGGER_CLI_IMAGE}

all: validate bundle #${CFG_BINDINGS} 

#list:
#	${GENERATOR} list

validate: ${SWAGGER_CLI_IMAGE}
	echo
	mkdir -p out
	${VALIDATER} validate /tmp/openapi.yaml
	echo

bundle: ${SWAGGER_CLI_IMAGE}
	echo
	mkdir -p dist
	${BUNDLER} bundle /tmp/openapi.yaml -o /tmp/dist/openapi.yaml -t yaml

#${CFG_BINDINGS}:: % : 
#	echo
#	${GENERATOR} generate \
#        --git-repo-id gigavueclient-go \
#        --git-user-id keysight.com \
#        -i /local/gigavue-os.yaml \
#        -c /local/gigavue-os-config-$@.yaml \
#        -o /local/out/gigavueclient-$@ \
#        -g $@
#go:: 
#	sed -ie 's^github.com/keysight.com/gigavueclient-go^bitbucket.it.keysight.com/qsr/gigavueclient-go.git^' out/gigavueclient-$@/go.mod
#	echo

clean:
	rm -rf out

.PHONY: validate resolve $(SWAGGER_CLI_IMAGE) #${CFG_BINDINGS}

# dependency images
$(SWAGGER_CLI_IMAGE):
	docker build -t $(SWAGGER_CLI_IMAGE) -f ./Dockerfile.swagger-cli .
