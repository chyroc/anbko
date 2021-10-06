package packages

import (
	"bytes"
	"reflect"

	"github.com/chyroc/anbko/env"
)

func init() {
	env.Packages["bytes"] = map[string]reflect.Value{
		"Compare":         reflect.ValueOf(bytes.Compare),
		"Contains":        reflect.ValueOf(bytes.Contains),
		"Count":           reflect.ValueOf(bytes.Count),
		"Equal":           reflect.ValueOf(bytes.Equal),
		"EqualFold":       reflect.ValueOf(bytes.EqualFold),
		"Fields":          reflect.ValueOf(bytes.Fields),
		"FieldsFunc":      reflect.ValueOf(bytes.FieldsFunc),
		"HasPrefix":       reflect.ValueOf(bytes.HasPrefix),
		"HasSuffix":       reflect.ValueOf(bytes.HasSuffix),
		"Index":           reflect.ValueOf(bytes.Index),
		"IndexAny":        reflect.ValueOf(bytes.IndexAny),
		"IndexByte":       reflect.ValueOf(bytes.IndexByte),
		"IndexFunc":       reflect.ValueOf(bytes.IndexFunc),
		"IndexRune":       reflect.ValueOf(bytes.IndexRune),
		"Join":            reflect.ValueOf(bytes.Join),
		"LastIndex":       reflect.ValueOf(bytes.LastIndex),
		"LastIndexAny":    reflect.ValueOf(bytes.LastIndexAny),
		"LastIndexByte":   reflect.ValueOf(bytes.LastIndexByte),
		"LastIndexFunc":   reflect.ValueOf(bytes.LastIndexFunc),
		"Map":             reflect.ValueOf(bytes.Map),
		"NewBuffer":       reflect.ValueOf(bytes.NewBuffer),
		"NewBufferString": reflect.ValueOf(bytes.NewBufferString),
		"NewReader":       reflect.ValueOf(bytes.NewReader),
		"Repeat":          reflect.ValueOf(bytes.Repeat),
		"Replace":         reflect.ValueOf(bytes.Replace),
		"Runes":           reflect.ValueOf(bytes.Runes),
		"Split":           reflect.ValueOf(bytes.Split),
		"SplitAfter":      reflect.ValueOf(bytes.SplitAfter),
		"SplitAfterN":     reflect.ValueOf(bytes.SplitAfterN),
		"SplitN":          reflect.ValueOf(bytes.SplitN),
		"Title":           reflect.ValueOf(bytes.Title),
		"ToLower":         reflect.ValueOf(bytes.ToLower),
		"ToLowerSpecial":  reflect.ValueOf(bytes.ToLowerSpecial),
		"ToTitle":         reflect.ValueOf(bytes.ToTitle),
		"ToTitleSpecial":  reflect.ValueOf(bytes.ToTitleSpecial),
		"ToUpper":         reflect.ValueOf(bytes.ToUpper),
		"ToUpperSpecial":  reflect.ValueOf(bytes.ToUpperSpecial),
		"Trim":            reflect.ValueOf(bytes.Trim),
		"TrimFunc":        reflect.ValueOf(bytes.TrimFunc),
		"TrimLeft":        reflect.ValueOf(bytes.TrimLeft),
		"TrimLeftFunc":    reflect.ValueOf(bytes.TrimLeftFunc),
		"TrimPrefix":      reflect.ValueOf(bytes.TrimPrefix),
		"TrimRight":       reflect.ValueOf(bytes.TrimRight),
		"TrimRightFunc":   reflect.ValueOf(bytes.TrimRightFunc),
		"TrimSpace":       reflect.ValueOf(bytes.TrimSpace),
		"TrimSuffix":      reflect.ValueOf(bytes.TrimSuffix),
	}
	env.PackageTypes["bytes"] = map[string]reflect.Type{
		"Buffer": reflect.TypeOf(bytes.Buffer{}),
		"Reader": reflect.TypeOf(bytes.Reader{}),
	}
	bytesGo17()
}
