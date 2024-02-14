package endpoints

import (
	"fmt"
	"net/http"

	"github.com/alice-lg/birdwatcher/bird"
	"github.com/julienschmidt/httprouter"
)

func Protocols(r *http.Request, ps httprouter.Params, useCache bool) (bird.Parsed, bool) {
	return bird.Protocols(useCache)
}

func Protocol(r *http.Request, ps httprouter.Params, useCache bool) (bird.Parsed, bool) {
	protocol, err := ValidateProtocolParam(ps.ByName("protocol"))
	if err != nil {
		return bird.Parsed{"error": fmt.Sprintf("%s", err)}, false
	}

	return bird.Protocol(useCache, protocol)
}

func Bgp(r *http.Request, ps httprouter.Params, useCache bool) (bird.Parsed, bool) {
	return bird.ProtocolsBgp(useCache)
}

func ProtocolsShort(r *http.Request, ps httprouter.Params, useCache bool) (bird.Parsed, bool) {
	return bird.ProtocolsShort(useCache)
}
