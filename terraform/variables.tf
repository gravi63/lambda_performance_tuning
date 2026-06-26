variable "lambda_functions" {
  description = <<-EOT
    Map of Lambda functions to create. Map key = function name.
    source_file should point to a single .py file in var.lambda_source_dir,
    e.g. "hello_world.py" -> lambda_src/hello_world.py
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
    # Add more functions here as you drop more .py files into lambda_source_dir, e.g.:
    # "another-function" = {
    #   source_file = "another_function.py"
    #   handler     = "another_function.lambda_handler"
    #   timeout     = 60
    #   environment = { LOG_LEVEL = "INFO" }
    # }
  }
}

variable "lambda_source_dir" {
  description = "Directory containing the individual .py files referenced in lambda_functions"
  type        = string
  default     = "./lambda_src"
}
