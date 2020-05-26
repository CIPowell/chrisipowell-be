variable api_gateway_id { type = string }
variable api_gateway_execution_arn { type = string }

variable path { type = string }
variable name { type = string }
variable handler { 
    type = string 
    default = "src/index.handler"
}
variable runtime {
    type = string
    default = "nodejs12.x"
}
variable method {
    type = string
    default = "GET"
}