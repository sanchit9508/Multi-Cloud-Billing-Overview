constant: CONNECTION_NAME {
  value: "cortex"
  export: override_required
}

constant: GCP_PROJECT {
  value: "GCP Project ID"
  export: override_required
}

constant: REPORTING_DATASET {
  value: "Reporting Dataset Name"
  export: override_required
}

constant: CLIENT {
  value: "Client ID"
  export: override_required
}

# By setting Sign Change value to 'yes', it's displayed as a positive number in income statement reports.
constant: SIGN_CHANGE {
  value: "yes"
  export: override_required
}


constant: negative_format {
  value: "{% if value < 0 %}<p style='color:red;'>{{rendered_value}}</p>{% else %} {{rendered_value}} {% endif %}"
}

constant: sign_change_multiplier {
  value: "{% assign choice = '@{SIGN_CHANGE}' | downcase %}
  {% if choice == 'yes' %}{% assign multiplier = -1 %}{% else %}{% assign multiplier = 1 %}{% endif %}"
}



