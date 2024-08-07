# Substitutions 

# ${v} - Substitue the value of v.
v1=1
echo "substitute value of v1 '\${v1}'"
echo "sub value for v1:"${v1}
echo "--"

# ${v:-val} - if v is null or unset, val is substituuted
echo ${v2:-2}
echo "Value not set for v2:" $v2
echo "--"

# ${v:=val} - if v is null or unset, vs is set to val
echo ${v3:=3}
echo "val is substituted:" $v3
echo "---"

# ${v:+val} - if v is set, val is substituted. v is unchanged
v4=1234
echo "val is substituted" ${v4:+44}
echo "val is unchanged" ${v4}
echo "---"

# ${v:?val} - if v is null or unset, val is printed to std err
v5=5
echo "no err printed as v5 is set" ${v5:?5555}
echo "value unchanged" ${v5}

echo "not setting value, yest printing results"
echo "print value undefined" ${v6:? "Value unable to find"}
echo "---"
