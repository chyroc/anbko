// +build go1.10

package packages

import (
	"reflect"
	"time"

	"github.com/chyroc/anbko/env"
)

func timeGo110() {
	env.Packages["time"]["LoadLocationFromTZData"] = reflect.ValueOf(time.LoadLocationFromTZData)
}
