package packages

import (
	"encoding/json"
	"reflect"

	"github.com/chyroc/anbko/env"
)

func init() {
	env.Packages["encoding/json"] = map[string]reflect.Value{
		"Marshal":   reflect.ValueOf(json.Marshal),
		"Unmarshal": reflect.ValueOf(json.Unmarshal),
	}
}
