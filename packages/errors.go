package packages

import (
	"errors"
	"reflect"

	"github.com/chyroc/anbko/env"
)

func init() {
	env.Packages["errors"] = map[string]reflect.Value{
		"New": reflect.ValueOf(errors.New),
	}
}
