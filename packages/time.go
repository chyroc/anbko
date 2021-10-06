package packages

import (
	"reflect"
	"time"

	"github.com/chyroc/anbko/env"
)

func init() {
	env.Packages["time"] = map[string]reflect.Value{
		"ANSIC":           reflect.ValueOf(time.ANSIC),
		"After":           reflect.ValueOf(time.After),
		"AfterFunc":       reflect.ValueOf(time.AfterFunc),
		"April":           reflect.ValueOf(time.April),
		"August":          reflect.ValueOf(time.August),
		"Date":            reflect.ValueOf(time.Date),
		"December":        reflect.ValueOf(time.December),
		"February":        reflect.ValueOf(time.February),
		"FixedZone":       reflect.ValueOf(time.FixedZone),
		"Friday":          reflect.ValueOf(time.Friday),
		"Hour":            reflect.ValueOf(time.Hour),
		"January":         reflect.ValueOf(time.January),
		"July":            reflect.ValueOf(time.July),
		"June":            reflect.ValueOf(time.June),
		"Kitchen":         reflect.ValueOf(time.Kitchen),
		"LoadLocation":    reflect.ValueOf(time.LoadLocation),
		"March":           reflect.ValueOf(time.March),
		"May":             reflect.ValueOf(time.May),
		"Microsecond":     reflect.ValueOf(time.Microsecond),
		"Millisecond":     reflect.ValueOf(time.Millisecond),
		"Minute":          reflect.ValueOf(time.Minute),
		"Monday":          reflect.ValueOf(time.Monday),
		"Nanosecond":      reflect.ValueOf(time.Nanosecond),
		"NewTicker":       reflect.ValueOf(time.NewTicker),
		"NewTimer":        reflect.ValueOf(time.NewTimer),
		"November":        reflect.ValueOf(time.November),
		"Now":             reflect.ValueOf(time.Now),
		"October":         reflect.ValueOf(time.October),
		"Parse":           reflect.ValueOf(time.Parse),
		"ParseDuration":   reflect.ValueOf(time.ParseDuration),
		"ParseInLocation": reflect.ValueOf(time.ParseInLocation),
		"RFC1123":         reflect.ValueOf(time.RFC1123),
		"RFC1123Z":        reflect.ValueOf(time.RFC1123Z),
		"RFC3339":         reflect.ValueOf(time.RFC3339),
		"RFC3339Nano":     reflect.ValueOf(time.RFC3339Nano),
		"RFC822":          reflect.ValueOf(time.RFC822),
		"RFC822Z":         reflect.ValueOf(time.RFC822Z),
		"RFC850":          reflect.ValueOf(time.RFC850),
		"RubyDate":        reflect.ValueOf(time.RubyDate),
		"Saturday":        reflect.ValueOf(time.Saturday),
		"Second":          reflect.ValueOf(time.Second),
		"September":       reflect.ValueOf(time.September),
		"Since":           reflect.ValueOf(time.Since),
		"Sleep":           reflect.ValueOf(time.Sleep),
		"Stamp":           reflect.ValueOf(time.Stamp),
		"StampMicro":      reflect.ValueOf(time.StampMicro),
		"StampMilli":      reflect.ValueOf(time.StampMilli),
		"StampNano":       reflect.ValueOf(time.StampNano),
		"Sunday":          reflect.ValueOf(time.Sunday),
		"Thursday":        reflect.ValueOf(time.Thursday),
		"Tick":            reflect.ValueOf(time.Tick),
		"Tuesday":         reflect.ValueOf(time.Tuesday),
		"Unix":            reflect.ValueOf(time.Unix),
		"UnixDate":        reflect.ValueOf(time.UnixDate),
		"Wednesday":       reflect.ValueOf(time.Wednesday),
	}
	env.PackageTypes["time"] = map[string]reflect.Type{
		"Duration": reflect.TypeOf(time.Duration(0)),
		"Ticker":   reflect.TypeOf(time.Ticker{}),
		"Time":     reflect.TypeOf(time.Time{}),
	}
	timeGo18()
	timeGo110()
}
