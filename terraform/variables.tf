variable "lambda_functions" {
  description = <<-EOT
    Map of Lambda functions to create. Map key = function name.
    source_file should point to a single .py file in var.lambda_source_dir.
  EOT
  type = map(object({
    source_file = string    # e.g. "hello_world.py"
    handler     = string    # e.g. "hello_world.lambda_handler"
    runtime     = optional(string, "python3.12")
    timeout     = optional(number, 30)
    memory_size = optional(number, 128)
    environment = optional(map(string), {})
  }))

  default = {
    "DDBCreateRecord" = {
      source_file = "ddb_create_record.py"
      handler     = "ddb_create_record.lambda_handler"
    }
    "DDBUpdateRecord" = {
      source_file = "ddb_update_record.py"
      handler     = "ddb_update_record.lambda_handler"
    }
    "DDBDeleteRecord" = {
      source_file = "ddb_delete_record.py"
      handler     = "ddb_delete_record.lambda_handler"
    }
    "DDBListRecords" = {
      source_file = "ddb_list_records.py"
      handler     = "ddb_list_records.lambda_handler"
    }
  }
}

variable "lambda_source_dir" {
  description = "Directory containing the individual .py files referenced in lambda_functions"
  type        = string
  default     = "./lambda_src"
}

variable "auth0_issuer" {
  type = string
  description = "Issuer Auth0 domain name"
}

variable "auth0_audience" {
  type = list
  description = "API Identifier you set in Auth0 dashboard"
  default = ["https://ddboperations.api"]
}
