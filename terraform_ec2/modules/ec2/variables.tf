variable "subnet_id" {
  default = ""
}

variable "root_disk_size" {
  default = 8
}

variable "instance_type" {
  default = "t2.micro"
}
variable "sg_ids" {
  type = list(string)
//  default = ["sg-07e5e688811968425"]
}
variable "name" {
  default = ""
}
variable "env" {
  default = ""
}
variable "key_name" {
  default = ""
}