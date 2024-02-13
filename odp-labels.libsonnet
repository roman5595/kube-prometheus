function(externalLabels, obj) {
  [key]: (
    local value = obj[key];

    if std.type(value) == 'object' && 'kind' in value && value.kind == 'ServiceMonitor' then
      value {
        spec +: {
          endpoints: std.map(
            function(endpoint) endpoint {
              relabelings +: std.map(
                function(key) {
                  targetLabel: key,
                  replacement: externalLabels[key],
                },
                std.objectFields(externalLabels))
            }
          , super.endpoints)
        },
      }
    else value
  ) for key in std.objectFields(obj)
}
