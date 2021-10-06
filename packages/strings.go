package packages

import (
	"reflect"
	"strings"

	"github.com/chyroc/anbko/env"
)

func init() {
	env.Packages["strings"] = map[string]reflect.Value{
		"Contains":       reflect.ValueOf(strings.Contains),
		"ContainsAny":    reflect.ValueOf(strings.ContainsAny),
		"ContainsRune":   reflect.ValueOf(strings.ContainsRune),
		"Count":          reflect.ValueOf(strings.Count),
		"EqualFold":      reflect.ValueOf(strings.EqualFold),
		"Fields":         reflect.ValueOf(strings.Fields),
		"FieldsFunc":     reflect.ValueOf(strings.FieldsFunc),
		"HasPrefix":      reflect.ValueOf(strings.HasPrefix),
		"HasSuffix":      reflect.ValueOf(strings.HasSuffix),
		"Index":          reflect.ValueOf(strings.Index),
		"IndexAny":       reflect.ValueOf(strings.IndexAny),
		"IndexByte":      reflect.ValueOf(strings.IndexByte),
		"IndexFunc":      reflect.ValueOf(strings.IndexFunc),
		"IndexRune":      reflect.ValueOf(strings.IndexRune),
		"Join":           reflect.ValueOf(strings.Join),
		"LastIndex":      reflect.ValueOf(strings.LastIndex),
		"LastIndexAny":   reflect.ValueOf(strings.LastIndexAny),
		"LastIndexFunc":  reflect.ValueOf(strings.LastIndexFunc),
		"Map":            reflect.ValueOf(strings.Map),
		"NewReader":      reflect.ValueOf(strings.NewReader),
		"NewReplacer":    reflect.ValueOf(strings.NewReplacer),
		"Repeat":         reflect.ValueOf(strings.Repeat),
		"Replace":        reflect.ValueOf(strings.Replace),
		"Split":          reflect.ValueOf(strings.Split),
		"SplitAfter":     reflect.ValueOf(strings.SplitAfter),
		"SplitAfterN":    reflect.ValueOf(strings.SplitAfterN),
		"SplitN":         reflect.ValueOf(strings.SplitN),
		"Title":          reflect.ValueOf(strings.Title),
		"ToLower":        reflect.ValueOf(strings.ToLower),
		"ToLowerSpecial": reflect.ValueOf(strings.ToLowerSpecial),
		"ToTitle":        reflect.ValueOf(strings.ToTitle),
		"ToTitleSpecial": reflect.ValueOf(strings.ToTitleSpecial),
		"ToUpper":        reflect.ValueOf(strings.ToUpper),
		"ToUpperSpecial": reflect.ValueOf(strings.ToUpperSpecial),
		"Trim":           reflect.ValueOf(strings.Trim),
		"TrimFunc":       reflect.ValueOf(strings.TrimFunc),
		"TrimLeft":       reflect.ValueOf(strings.TrimLeft),
		"TrimLeftFunc":   reflect.ValueOf(strings.TrimLeftFunc),
		"TrimPrefix":     reflect.ValueOf(strings.TrimPrefix),
		"TrimRight":      reflect.ValueOf(strings.TrimRight),
		"TrimRightFunc":  reflect.ValueOf(strings.TrimRightFunc),
		"TrimSpace":      reflect.ValueOf(strings.TrimSpace),
		"TrimSuffix":     reflect.ValueOf(strings.TrimSuffix),
	}
	stringsGo110()
}
