// +build !appengine

package packages

import (
	"os"
	"reflect"

	"github.com/chyroc/anbko/env"
)

func osNotAppEngine() {
	env.Packages["os"]["Getppid"] = reflect.ValueOf(os.Getppid)
}
